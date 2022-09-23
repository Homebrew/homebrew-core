class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v4.2.2.tar.gz"
  sha256 "db5426766c7d9f23fb269fa27c725af459728a3d3a1b0642dc823fb7b26a8f93"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19fa1b48d9f9dc3d0761855e4d9a2bae3695b0511df590e6ba7cdf4ff67fb7b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9165915484bf6af9521934c35035f23b4f97dbace2b138d150cf4e4cbae85442"
    sha256 cellar: :any_skip_relocation, monterey:       "910f75047a4717aebf62a84d98fecd431ac5d69a957c5c1ac094bb7aed6810a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5d2b01abb524c254383f02c91dd4705908355b659f171feb5daf7162b44c724"
    sha256 cellar: :any_skip_relocation, catalina:       "c1243e82c6d22aa8bcd79e3e4b742c69c96728f1a93fd7e2ee1bec6f1ad89eff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eaeab02a16ccf747ff2b8c7950a0068431fcb908e6ccef2dee7c121c04c1a89"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n\r\n#{json}"
  end

  test do
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
