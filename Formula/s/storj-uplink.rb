class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.153.2.tar.gz"
  sha256 "f19c095f1ab264073c7f68e97594ef1314aae560d237db012bb4786f4b5c94b7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02ebcefc3a5cd970b2c568b2ad97c31a03fd3e95f06d38dea16b7b104d9f6890"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02ebcefc3a5cd970b2c568b2ad97c31a03fd3e95f06d38dea16b7b104d9f6890"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02ebcefc3a5cd970b2c568b2ad97c31a03fd3e95f06d38dea16b7b104d9f6890"
    sha256 cellar: :any_skip_relocation, sonoma:        "38b5c46a9b149ff4e9c78167315704698607c783db2a57427d143a268aadaaaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a3866885b22a39806b739eee99e69634a08ee9121895f8d24aaeb18c18731e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99f9cac3f5efec3733aca7b9406a3667e18ed35631525f93eb80936fba65b962"
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
