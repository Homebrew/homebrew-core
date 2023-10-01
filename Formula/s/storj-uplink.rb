class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.87.3.tar.gz"
  sha256 "071f6186cd72897bc2f595ecc55dba77040d557b69eb69611c8a1c4b1e336c6a"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bcb6d2b7ffd074c264c8691e78d42f756a898a276b09fa90bb5270aae528b37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8e3132fa44b1e95bc6938aec81c3b22456c66690c1db340baee3f5e11e81af9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab873d7457e3f23276773e4d74b5818a42ddeba20ee26835b480580664982daa"
    sha256 cellar: :any_skip_relocation, ventura:        "2de5ff9e6c7a6253819bc04bc89aa9463ac838fcd33df8fbae697352eca6ac79"
    sha256 cellar: :any_skip_relocation, monterey:       "86980a9335dee350f33b9f4fcb131014661e35f540e36dcf9100898538301c51"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cda9639d01b8b61506e32e5dced14f10d3ccf56b89303a86e8d7aa1f1502dd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b24639a390cb3b6fc7ad71f9d53a6e662cd81fece995fa5ab716cb4f8d0dc03"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
