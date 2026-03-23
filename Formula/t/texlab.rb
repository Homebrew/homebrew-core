class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://github.com/latex-lsp/texlab/"
  url "https://github.com/latex-lsp/texlab/archive/refs/tags/v5.25.1.tar.gz"
  sha256 "7d8435761b0012b6de1cfdb4db37f5eafcba8e670530ef1df44aa9934eef0887"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9376f7602a35d01e37ed4b77f3f24d3e7a43ca4d0acd2e9a1ef767b8679a68ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6179eb9a7b3d9c97db2022a80e9bbfcfd30f4c362143faa0be707943e84a27f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a972dbc7415f5852c580396b52acf2852e2a14df9f6162a06d009c78235a2ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "44a52722139efe8a385787d1c68fe16bcc619bbd1cf7e0096060f441509255bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81ba303fcda29afc73b3cd919511f64a5633a24bbc31130c6e814ea1632f2f26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77a7631e84cc28f6adbf5d55a2797904621be5b7b4f173383f33ae2bff3dce24"
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
