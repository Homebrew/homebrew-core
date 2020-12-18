class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2020-12-14",
       revision: "dbd0cfba531c21de01af7b1a12ce9eb6b1271a5d"
  version "2020-12-14"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf83477349f03f86f774e56d12d7929081a51f0427d4a8b4eff853c3a6a31fff" => :big_sur
    sha256 "f6b48a9fb3dc4bd658655fa5eb0f2818d9e4c2c47e14fef6a7c1745efcae4343" => :catalina
    sha256 "eae2738cc02163307b88cc52c2847e8b10239249b5256f3aceebe1f191608e17" => :mojave
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
