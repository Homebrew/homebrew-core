class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://github.com/latex-lsp/texlab/"
  url "https://github.com/latex-lsp/texlab/archive/refs/tags/v5.21.0.tar.gz"
  sha256 "723099514ffb7a6537f486de951ae2cfd97d2ae6420aa1ff8eb6ed4068ecb160"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf873b3f175710333eeda935ef15729298fb9f5f6b0cc820f8b36403d93df5b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72d5ce01584c6a3f0315d587daa80d53b74c3f9b38aaf3a892a347a963a3f4a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "191c5af9e4694784b990ef33adabde30f33047c512aa3c83b5042c67579f8184"
    sha256 cellar: :any_skip_relocation, sonoma:        "89d6073155dbc520d61a92f85c5a4e63a95b36c399ef1fb809506e75733449fc"
    sha256 cellar: :any_skip_relocation, ventura:       "ba154dd6573a6e096e068f432e7d9f21cb2a3eea5d63fd9f2e96d95a967b5e54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bf523fa4943677f4e8188501df87968ad3aefa863548c6b5dabc6229f020762"
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
