class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/refs/tags/v5.12.2.tar.gz"
  sha256 "679d72a73269addcd870d6742b418aed2fb7e256137f360e2cc80271f20f0704"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52ddf0b0e5d8b8c66841d0012b267a940691e5e0b67f28296aeba9e0679971e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "351d52861ddadcaaff35e6b3f21bc72bc9f0f4d0953862af8dbbccb2391ff38c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01be25897d8a9a58698d6384d6cf51558a6ada6d2edb7a8844b79b3b9444ab73"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ba29143621d9f69c3a78ebdb44cccd8f5677d2bad2abe7c2b9ffdb697679118"
    sha256 cellar: :any_skip_relocation, ventura:        "7026915c1d52f53e9ebec233ed7586fa2dc02eb2d5e2e65dc2102e69604b39a8"
    sha256 cellar: :any_skip_relocation, monterey:       "86cf24c335dd42ee9d15320a874129a298e2c44ce4b4fe5ae86e4bb2a3ecd4ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee487fec9a60706520965983b0977fb168b5e9708d9d306907ee04974846accc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/texlab")
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
