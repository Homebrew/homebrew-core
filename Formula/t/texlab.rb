class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/refs/tags/v5.13.0.tar.gz"
  sha256 "0b35f954b70f98282f7db4e0e1503de0abc40f986069546496c5b0555103e3b4"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "641bfc71f9b87c3f508e4b1adc2d89b33cb3961c515b6daed2e7c2ddab44018d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d281eaef4e262f82019447252c2c40c6e2f08b36b951524f0e09d2ff4ea8b810"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caeba80ff0df67c22ad617e4565439f1a1ce334afa9ebccbed4bd8f1acc19182"
    sha256 cellar: :any_skip_relocation, sonoma:         "36544d4fe9cb96c213f4aa007165d4f7e49c06df0b171cb5248781df9e865353"
    sha256 cellar: :any_skip_relocation, ventura:        "60da1c208f49f45cb23e69c36b6e29e4be1e34930d97cc7b49be5155ce0fa155"
    sha256 cellar: :any_skip_relocation, monterey:       "f20d1ab33fc66367e608f9f9cec6871ef313a4dcac9cea2f21a0407ed2c1f63f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baba67f99a1a1d8ad6bb5a340e7deb492b37cb3dcb2c22e24e341e287e61bec9"
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
