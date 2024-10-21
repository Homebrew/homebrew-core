class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://github.com/latex-lsp/texlab/"
  url "https://github.com/latex-lsp/texlab/archive/refs/tags/v5.20.0.tar.gz"
  sha256 "7f110967b75ac0c50e773f5af5ad9b67c4544ca2545f43662f6ae7918ca5d9c6"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f692fdec2584137d35d6dda5b0f6c39a112b4f2a1842c4c77f652773f13d34d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caef13f6f7edf714d54818573f0dff3d1998890837eb2730977ca8234d92fc99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "223e99c163f48bafe5a4b61d4fc946c7a6ee5a642196041a7d9157652430c4bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b30c4986cf380dd95a7c85d5f6a88cb90adbac76b36d49d9280894d64597a201"
    sha256 cellar: :any_skip_relocation, ventura:       "29e2acef64469752274dac0c863dedd27394043040b1270f8b546ba2676cbb93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "935888291d0bd104fa44cad75eb559a20ef33034dbb2b5eb053d5ce259c19772"
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

    assert_match output, pipe_output(bin/"texlab", input, 0)
  end
end
