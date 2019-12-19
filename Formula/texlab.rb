class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v1.8.0.tar.gz"
  sha256 "af644d2555c3852513135e87dc6f9bc8b5ee789a4f1c151f4478d108fa007c49"
  head "https://github.com/latex-lsp/texlab.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b21e7ccb8ba6e2e714543d39e9b1c5dfaacf2fdc0fb5b523900464520762ac76" => :catalina
    sha256 "8aaf1f88ec5f3c1a7dba5934cdf4ae3aaab5de0cc406039ba7af151ef146ca9a" => :mojave
    sha256 "8ff6bc889d612a421272f23df4c813b4e1e9411bd88e97bc653a2c06841c87ae" => :high_sierra
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
