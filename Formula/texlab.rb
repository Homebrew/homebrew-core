class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v2.0.0.tar.gz"
  sha256 "72fe464a7f148843a1076041e3a5888a2b1c06be63790a32dd85725d114d3828"
  head "https://github.com/latex-lsp/texlab.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a156dda97ac1638b77569c6c7022a44abc7231a35a9ab940277f4d25a38007f2" => :catalina
    sha256 "d3932f321de224ff58e0227951ad06336534580f6c6900c3154b5a12ff0d60f1" => :mojave
    sha256 "fc26b11b88df5f255a662f61bfa472d21e1adc54e883c0b432f04868236afc19" => :high_sierra
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
      assert_match "Content-Length:", stdout.gets("\n")
    ensure
      Process.kill "SIGKILL", pid
    end
  end
end
