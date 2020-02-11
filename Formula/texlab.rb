class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v1.10.0.tar.gz"
  sha256 "af8686a84983992487e2ec2df61478a62581db0d803dcbd77727fb969fd694c0"
  head "https://github.com/latex-lsp/texlab.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "00873c7c9f05c736f8f8f449311d50951e88b846f3ef1f73f351546bfda67aa1" => :catalina
    sha256 "be27218a856605bb68c949314388de8cd4d41e7bad34d6e937ac2dfcdfd83465" => :mojave
    sha256 "113a8623c118bf0d370f8a49640a01dd6f4e82c9edc956a38097ce9fd63c0b95" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    require "open3"

    begin
      stdin, stdout, _, wait_thr = Open3.popen3("#{bin}/texlab")
      pid = wait_thr.pid
      stdin.write <<~EOF
        Content-Length: 103

        {"jsonrpc": "2.0", "id": 0, "method": "initialize", "params": { "rootUri": null, "capabilities": {}}}

      EOF
      assert_match "Content-Length: 543", stdout.gets("\n")
    ensure
      Process.kill "SIGKILL", pid
    end
  end
end
