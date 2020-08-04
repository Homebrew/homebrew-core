class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer/archive/2020-08-03.tar.gz"
  version "2020-08-03"
  sha256 "67126298dd72c3561e14e1c7dc1b38477ec91b30d039071a36c8b3f3441a169f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "02069d326cd095fa9adc50ce537ef489b69d1a8e8186c3bb3af9e93cbd38f1cb" => :catalina
    sha256 "ddaccdac560dcf8895474bb0bee78b2d84da8cdf865447d4202447ea6dc69cca" => :mojave
    sha256 "dc04811c17749f6e2284e00405698b6854226df467e0e8e1dd8653aae88d7673" => :high_sierra
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
