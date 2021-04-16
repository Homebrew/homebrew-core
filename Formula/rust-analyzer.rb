class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-04-12",
       revision: "7be06139b632ee615fc18af04dd67947e2c794b2"
  version "2021-04-12"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "12d1914a94ad94e12f351734a572f4a0434e2152c00cf7164c83d21370838aa3"
    sha256 cellar: :any_skip_relocation, big_sur:       "4eada98a74764b04716503af03b36a72399d41dd5590832fd08138e674abae25"
    sha256 cellar: :any_skip_relocation, catalina:      "7bde122c7505ce0b4b63ffe4637eaee31e63d4ab33a28eda6d7d65ca203b21c2"
    sha256 cellar: :any_skip_relocation, mojave:        "f2ab0d65100516e030929cb7a0477ade931ed17fbbec57a704ffba0d4d9ac126"
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
