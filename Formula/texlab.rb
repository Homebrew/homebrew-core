class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v2.1.0.tar.gz"
  sha256 "dd966f427d657b25b05caf3df207da57d8f19115aa63d791f3bf70b6ffc4b9a8"
  head "https://github.com/latex-lsp/texlab.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b5adb43003d51918dcbbac31f5970a485f3307330ae130fa9135c83c45152da" => :catalina
    sha256 "3b9562f1ec9437a1fab3f1716a3fa90d6881e76010a0332a5db9166a0fa9e038" => :mojave
    sha256 "5a0849d1364784424b9e60522ac29b958b3eefba891dfc88cac78e6003d1128b" => :high_sierra
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
