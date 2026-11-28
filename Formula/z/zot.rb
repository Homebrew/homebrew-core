class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.91.tar.gz"
  sha256 "ba5e3168db1ac6e49602e405c5286de2b901dc7219aa61fd24b51e3fdf0ebd8b"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    manifest_sha256 "4ef5f5c38135ec984d1145ef498368a62570b718047bb449b13215ff6cc9641f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1771a1abc57b5a21ca9a102e7fd0a6539d3034b78fc4e24ba7da2ec34d051267"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1771a1abc57b5a21ca9a102e7fd0a6539d3034b78fc4e24ba7da2ec34d051267"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1771a1abc57b5a21ca9a102e7fd0a6539d3034b78fc4e24ba7da2ec34d051267"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6d974d5aef63ad6521ffcbee5ffa8cc3e2f9048722f7b0e7a3fa10fabd09e2ac"
    sha256 cellar: :any,                 x86_64_linux:      "1c191b149083bd1f6c82b4a20d928e22aff3e6e52d842def3803e583faba4116"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
