class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v3.3.2.tar.gz"
  sha256 "380395a37ee2ece590c0db04ac4898f5f430ee37d0ab0fa0801805167fff066a"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e6c6579f14b369215a26f8e05bbdeb4b245a6142df3c470e46430f8b517bb7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aad770a9da7aa03b4a72a2156a3392c6a40759ce730a3aef80e78ccc81693efb"
    sha256 cellar: :any_skip_relocation, monterey:       "0f19090f58cc85a63a1fea0c9039bc948c6bf56c78ce36c0452147d59119d5c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a57291d25a1e5fb1a1de4f6aacfa25672044bb642a82cfe8e5cd0769f47c8c36"
    sha256 cellar: :any_skip_relocation, catalina:       "ff9008fa28752508f19d90f04baf2b83220b1662d77baf48db571bcab3cb617e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0aaf981f93f011a183cd38d4d0adece290908735785d5196d2965c2de674cab5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    def rpc(json)
      "Content-Length: #{json.size}\r\n" \
        "\r\n" \
        "#{json}"
    end

    input = rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id":1,
      "method":"initialize",
      "params": {
        "rootUri": "file:/dev/null",
        "capabilities": {}
      }
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"initialized",
      "params": {}
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id": 1,
      "method":"shutdown",
      "params": null
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"exit",
      "params": {}
    }
    EOF

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/texlab", input, 0)
  end
end
