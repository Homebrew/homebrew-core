require "language/node"

class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v1.7.0.tar.gz"
  sha256 "aa36f3f23656da0d58357fe044d2f60bc01a99bbaa2481132231f4791ff82d17"
  head "https://github.com/latex-lsp/texlab.git"

  depends_on "node" => :build
  depends_on "rust" => :build

  def install
    cd "src/citeproc/js"
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "dist"
    cd "../../.."
    system "cargo", "install", "--locked",
                               "--root", prefix,
                               "--path", "."
    bin.install "target/release/texlab"
  end

  test do
    require "Open3"

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
