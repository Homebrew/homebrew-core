class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-03-08",
       revision: "d54e1157b66017e4aae38328cd213286e39ca130"
  version "2021-03-08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e64014cb9bca861f84b4c002f06411ec6dafd5f7a18f99e86fd0c8d0cd17af4a"
    sha256 cellar: :any_skip_relocation, big_sur:       "16d318360f30c5f84dad2e6a02b0ece00744e70573e655c3b97b22559381df6a"
    sha256 cellar: :any_skip_relocation, catalina:      "9ec323a1f3cd48ac7009281679003dfe97af3447387958654fd4cd3c3ae43913"
    sha256 cellar: :any_skip_relocation, mojave:        "7a2fed68878ff7ecd19818c9f9ba1fbf901fa2230ed86c10af0757f3655dd235"
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
