class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.131.3.tar.gz"
  sha256 "56c11f73d5c9c83f834251ac5e66ee15daa08b793ca6df5e3c2be873b21c42de"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "715d281df80a3f101fef8a04d0fb73153477174eeefce403817491d624bdb294"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "715d281df80a3f101fef8a04d0fb73153477174eeefce403817491d624bdb294"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "715d281df80a3f101fef8a04d0fb73153477174eeefce403817491d624bdb294"
    sha256 cellar: :any_skip_relocation, sonoma:        "f516044779159446d3f4f9cfd907cab734af55107409f1b0853f31a02c0349aa"
    sha256 cellar: :any_skip_relocation, ventura:       "f516044779159446d3f4f9cfd907cab734af55107409f1b0853f31a02c0349aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b4098aabb87904e7f20d095956ff95f7125ad526a0d20d6ca4b2ab51b7d9d1b"
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
