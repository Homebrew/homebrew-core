class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://github.com/latex-lsp/texlab/"
  url "https://github.com/latex-lsp/texlab/archive/refs/tags/v5.24.0.tar.gz"
  sha256 "5018eb803875e9c6e03656e88ed6121214dacd24e94ea7b83710197c9ee819c8"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bae63ec92296b2e02529d96a69287db0d52148d1297d1cbdb7680882a3babdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9a9287a4293c57b60fd667a3eb12bb43ea54b87ca8f86af6197f1b1c3d4ee5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c51e28d0519134a6aac372d214806a8a0db78a50439ff1e4ae6f0c6003d52e6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c208969d693b993c62c08b2d22aee7ffea1eaf6570ac390a61685321c76f2afd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "336de87208b4cb27f943c3399c1baa6ca2d7ff7f38ae6a687a681bda6e025ca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4faa4f344ba54bb4694188edf6d89ad0762b8b3ccfaf2f26b202705b5dc12df"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/texlab")
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n\r\n#{json}"
  end

  test do
    input = rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id":1,
        "method":"initialize",
        "params": {
          "rootUri": "file:/dev/null",
          "capabilities": {}
        }
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"initialized",
        "params": {}
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id": 1,
        "method":"shutdown",
        "params": null
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"exit",
        "params": {}
      }
    JSON

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output(bin/"texlab", input, 0)
  end
end
