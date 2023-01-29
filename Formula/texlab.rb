class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v5.2.0.tar.gz"
  sha256 "e23bff5b39d8605a2e1b789e25015332a5777cfb53b3d24535ceef0034437929"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f01e114b107df11407888fc2f980130efcb9fe651e739514f6ba3685b39eaaeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1f9943f19a39662203ed21efd084484f156108f65b8e1c553a1fcb5c5380ef0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0ca4e9cc4e79be0b2c579e2da85f1c385bb76acce6fabda546b1bbb392a82ac"
    sha256 cellar: :any_skip_relocation, ventura:        "52836ae3d38a9aea9d6b153b06a0a4a72574fe3390d7cc22ffdaece3efe5ae57"
    sha256 cellar: :any_skip_relocation, monterey:       "5dc4d1eaefb6c29e9dc01dc4ff6eae2087e8d4b84570eb247ec17b418f451c10"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccd57fd87b88448ba8452ac253f0102fc1354ff7223c1e6d026283ef663338ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a72e532d3b6cdd551a32758a9636e1a4f384211489436cc811a1a2478c91c20"
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
