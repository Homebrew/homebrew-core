class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://github.com/latex-lsp/texlab/"
  url "https://github.com/latex-lsp/texlab/archive/refs/tags/v5.16.1.tar.gz"
  sha256 "f9bdf5511b184bca41610be6d5eef74fb8042b758b2ecf79bce266085d8bc045"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04a67337078cf18113d95fd9c0610445ba35acbc1bc4af30661d34ab4f4c88a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "062307da6afc5c97a3be1e4dace4745bf4a0d05a74b65451a9e004e6253bac76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec76382539b2571b2516f7dd6027bc28aa3a3f57d09023b15dcd1fee390ec2cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "f54d4ed5f4cf0e18eddbe1d6978f342cd240681da6b6b40197e2d84c8bf22254"
    sha256 cellar: :any_skip_relocation, ventura:        "dde204b09943c8b54a9a8408d39375853c863139d71e262d58644be5fba69849"
    sha256 cellar: :any_skip_relocation, monterey:       "bbfaee7abaab7e2a335c405d95162f5ebbd2ea84a1ba5dd72b8ecca4b654d420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "454e8b5836d18009df5ffc28f18fd7cf4f76b7a300992df4b9007c4b9c08b4b4"
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
