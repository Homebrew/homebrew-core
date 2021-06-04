class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v3.1.0.tar.gz"
  sha256 "772d4fa4fa0663dd00e2213e0d33a77b4bae2f36ea8b8e72cc7f85f77fb8f59f"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aa01f020ce432547ba9b88510359868860cd79403eb7934edcc4321c37663596"
    sha256 cellar: :any_skip_relocation, big_sur:       "10fcd4d803c4b2df5185ae5e65b2f98b91e7518f302e8fa89e1cfa3e3b9e436f"
    sha256 cellar: :any_skip_relocation, catalina:      "9065345367fa53592dd9fb282d9b91abbece52937718e7d1ed18de9dc403b2d6"
    sha256 cellar: :any_skip_relocation, mojave:        "058addfe3c8997d291b1d4ca58714a7988449c3c88c6ec18195d0d4e5e57795d"
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
