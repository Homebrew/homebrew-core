class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v3.2.0.tar.gz"
  sha256 "230fe594ceeb2e64f60776ef00c2674dda5b2e10e960b051536336c94c7523b0"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ace13aa023a0f469b5a8d6f84866df772aec49df9da25ed8f3956655178ebf4e"
    sha256 cellar: :any_skip_relocation, big_sur:       "bc5bbf32d1c5faf7dd0996b992a2f9c78b27c3ed6187850521917ea61849b6e1"
    sha256 cellar: :any_skip_relocation, catalina:      "f8801c58a8bf07e9a4a9b506b11ce538fa17db718338f0fd1d962378a3791e8b"
    sha256 cellar: :any_skip_relocation, mojave:        "662267d2e6bd6d36cc5066b36807625d0de0fc03cb5c4709434872d51700803c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f17ba954bc373e843a9a1be540e6b08551c3e5fc9d35fb27f883369bcfa361ca"
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
