class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-02-08",
       revision: "336909b63a14b801520c6627d90d750babcfe280"
  version "2021-02-08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a334c8a1cee76936451dbcc938c732465d2e633fbb563ccf8a39004bcd964c77"
    sha256 cellar: :any_skip_relocation, big_sur:       "b689a28a39a76b9aa9a6946c4f9eedf7013f8f8e18e54dd7092ca3f373e78f85"
    sha256 cellar: :any_skip_relocation, catalina:      "421eefb37d897918978a9d33d48eaff62ac64d0f2e0f14abe70356affae60fd0"
    sha256 cellar: :any_skip_relocation, mojave:        "85af71103f6fc504341a9214709eb20064d281eccad3202054ca4f3fae6c8dc6"
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
