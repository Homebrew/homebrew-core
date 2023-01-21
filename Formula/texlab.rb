class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v5.1.0.tar.gz"
  sha256 "e327c78e079dc94290b34065cde92510f02db3f012aedcba4eb882bfc815cf55"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3c8e7d2834336cb309a0fdc4b56f65b4d4608ca5551d2de84ca12628eadf363"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9127f05710ea3a140314841e905a33f213c7228b617f689b657cfefed5492367"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5e4de6380ff4c151b983f993e363c7257842d8bcf974103e6264cd02d616731"
    sha256 cellar: :any_skip_relocation, ventura:        "8dd7ff3e1dc57f73599ca4455756febd475e69bd4071775261edbef6e45060d1"
    sha256 cellar: :any_skip_relocation, monterey:       "6e84f045740a083a188b6c9c9104954aa18ff4f54b3e0221d697985cf7027976"
    sha256 cellar: :any_skip_relocation, big_sur:        "c530416eff61c2e5c477e147e2d568a7efc3a5fa40ed8199cd40a08803a62c52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83dd76da01b226d9aa4053c728f60ba75eb1044a6f70fa4ae6105fdd3bba57fd"
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
