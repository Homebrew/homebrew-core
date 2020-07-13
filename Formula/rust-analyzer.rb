class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer/archive/2020-07-13.tar.gz"
  sha256 "e4176167bba26eeb7bc7bbf5be45d261e05e231331135dfbc6f12f927ac6eb60"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2fd68c0cd998f6d9543b2fa606775a4e5c7d6bf4e5ddd9c6cc9e7ac1370c73e" => :catalina
    sha256 "247acaf108accbbe071330a0da99f037d5a2a8e9d08f72f6831a3c02d3866aa5" => :mojave
    sha256 "86667de9d066a8ae0a29c41f8818e27efd9b9902bc12ca3bc7f16df004e9754b" => :high_sierra
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
