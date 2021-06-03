class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v3.1.0.tar.gz"
  sha256 "772d4fa4fa0663dd00e2213e0d33a77b4bae2f36ea8b8e72cc7f85f77fb8f59f"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ff791d68c78982b5854ab833cf716ff1fdd015561fa3ce879ae0a3fbb633466e"
    sha256 cellar: :any_skip_relocation, big_sur:       "aaa31b7aae793d6c0aadf43e742991209c5647e94b54c1e023702b8847654ccb"
    sha256 cellar: :any_skip_relocation, catalina:      "6e14171c9d65273d3284ddbd36e3fb2d48e385f7c780944beea601ed097c6ccf"
    sha256 cellar: :any_skip_relocation, mojave:        "82ed8db0eb1500c8eeaa18b8c1f977a8cccefdda0b4cf0a1e83c7f3f21328f50"
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
