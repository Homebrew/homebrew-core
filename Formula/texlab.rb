class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v2.2.0.tar.gz"
  sha256 "313b7c230c71a0087a2a5aadbba1d8ba1a929e1e8f98b8b7553ca956fc567835"
  head "https://github.com/latex-lsp/texlab.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a055d44ce4473a13978abaf7274977494ab831245cd31a114ad144f3db4d1f5" => :catalina
    sha256 "018c6135db719ab45b0b45379c5d67de4d7053a665ce9371c22cb4b61a77ea45" => :mojave
    sha256 "fb41342174c931311937c24ccebb1c2d5b228a98c21e3ed607e9187088cd80fe" => :high_sierra
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
