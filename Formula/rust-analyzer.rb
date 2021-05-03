class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-05-03",
       revision: "eb741e895f1a73420a401f2495c711afe37d9d19"
  version "2021-05-03"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d871ae4977b04db7e6d20a932328affeade2c52f1ca0060a3eafb7467c350a33"
    sha256 cellar: :any_skip_relocation, big_sur:       "e08aeba1163a0ef5945b6f473ece49bc2d080b9a47461a604f31acefbb000863"
    sha256 cellar: :any_skip_relocation, catalina:      "3af9aa2b0fb9e18a15aab9f6a2870867a3175cda044519970e6b84b86633b436"
    sha256 cellar: :any_skip_relocation, mojave:        "65c8ecc7804108313467b65f7419bf0819ceffaee8328932fed8f143dd028025"
  end

  depends_on "rust" => :build

  def install
    cd "crates/rust-analyzer" do
      system "cargo", "install", "--bin", "rust-analyzer", *std_cargo_args
    end
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

    assert_match output, pipe_output("#{bin}/rust-analyzer", input, 0)
  end
end
