class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.137.5.tar.gz"
  sha256 "d38e4500c18036951426407f004db55aeb65675eb357ca549f2211fae96f9caf"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d32dae722294e9b1665f4adda7398acd01dfc16298bc0e213766f3d12ad0a3ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d32dae722294e9b1665f4adda7398acd01dfc16298bc0e213766f3d12ad0a3ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d32dae722294e9b1665f4adda7398acd01dfc16298bc0e213766f3d12ad0a3ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "07068d5a0bf0893e5666a7419e4219be40201458c4479bcef16472a55b7e4ba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0478cd127266420b79ff0c3596f7103410041e0f480acaedaaf05b5316e2106a"
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
