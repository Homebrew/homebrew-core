class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.160.3.tar.gz"
  sha256 "c8f7659baf097d9f6c2dd8d5e18f1b80ffada3bf06ac83b3108afc9290948544"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b051eb51a719137b34ecdfa659a3aedb14b756add4fba33cb6bbbc091e61ebe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b051eb51a719137b34ecdfa659a3aedb14b756add4fba33cb6bbbc091e61ebe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b051eb51a719137b34ecdfa659a3aedb14b756add4fba33cb6bbbc091e61ebe"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7a8b20dec6f4de4803e4bdadc051d8cf4afb4574f0602f0b204dbc6c868bde1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "090637d73410f2d12b2c34ade057d54855733fe40c2550c83a6a8417bc936699"
    sha256 cellar: :any,                 x86_64_linux:  "52b9ccc98b01bc19896d939e009ee19b3549a75db89211637e3be7add541a7ba"
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
