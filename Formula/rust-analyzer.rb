class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2020-10-26",
       revision: "eae54b5f72baa1c1331720b0a46fe8aab01f186b"
  version "2020-10-26"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5bb62ae75666528cf6d58b6e5b6af2b6d0a161b4a8215f2419afb2a19400521d" => :catalina
    sha256 "e098e2ada1573fa8212d566c94f939d6c6b09b98f6fcade30952e0db0cd64512" => :mojave
    sha256 "ea1b7ac63f646e72bdaf78010b5ec6118ab012f54c0eba529adc54afa315f0d3" => :high_sierra
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
