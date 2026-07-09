class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://github.com/latex-lsp/texlab/"
  url "https://github.com/latex-lsp/texlab/archive/refs/tags/v5.26.0.tar.gz"
  sha256 "47af7e71247fe186ddbaa62373ce5fbebc802ab8df9924958ac62788a644f84e"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96ecb13453b54ba2ae5c0aeda507bea6346cdb6b014c01380d5a92175b298a9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b857d55b6c5fcd0e7019bb7eb40891591eb69d64817b6c28b1405b330be46281"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3089877fe36b5d51abb9f23df423a3570170a506e2c2525546d198fda0f7a5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8850b907d971f67f21684de385f8574f9433cdab57de3dd8a1d5c1cd4a24795b"
    sha256 cellar: :any,                 arm64_linux:   "693e40bb269bbc3020931b51c2480b80382fab2d9786b585d879b0a318a77d9a"
    sha256 cellar: :any,                 x86_64_linux:  "9a1727d46671375551aa8336d7e3a749e1f030c1fe8a19095d906d7a46e41a0a"
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
