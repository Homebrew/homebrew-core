class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.128.3.tar.gz"
  sha256 "d98c7e97727c3244cb36c07c8a9f366885ef6b28dec9e93211cf0f1b05baed68"
  license "AGPL-3.0-only"

  # Upstream creates stable releases and marks them as "pre-release" before
  # release (though some versions have permanently remained as "pre-release"),
  # so it's necessary to check releases. However, upstream has not marked
  # recent releases as "latest", so it's necessary to check all releases.
  # NOTE: We should return to using the `GithubLatest` strategy if/when
  # upstream reliably marks stable releases as "latest" again.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "849ece046be7062a7d948935d050f946b9f8835f246dc695e06a47a2b128ddd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "849ece046be7062a7d948935d050f946b9f8835f246dc695e06a47a2b128ddd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "849ece046be7062a7d948935d050f946b9f8835f246dc695e06a47a2b128ddd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b6268e3f1b812adcfc7695ebdc6d1788505e782a2f099b73d4c9fecca7aadba"
    sha256 cellar: :any_skip_relocation, ventura:       "9b6268e3f1b812adcfc7695ebdc6d1788505e782a2f099b73d4c9fecca7aadba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11e14951d4d92cabacb1ecbed1e0163f3ca86387dcf3333810a56af5a90c883f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~INI
      [metrics]
      addr=
    INI
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
