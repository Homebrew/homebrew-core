class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer/archive/2020-08-03.tar.gz"
  version "2020-08-03"
  sha256 "67126298dd72c3561e14e1c7dc1b38477ec91b30d039071a36c8b3f3441a169f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "89dca5c6b691b7b8ee31594cddc0c0e6a691efeef8a0924d12c73dc74dbac660" => :catalina
    sha256 "d3cd3df3d6b1fffd482aba451b150b5b050d48d50878d40ee47c76f671709c88" => :mojave
    sha256 "1281391e3ea1f39903ba932e3e5095e6bdcabaa73a1319f5110a0f6078700805" => :high_sierra
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
