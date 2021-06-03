class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-05-31",
       revision: "f4383981249d3f2964f2c667f3349f8ff15b77c4"
  version "2021-05-31"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f3bd5e78a119d9280770f3b56f22e6ac811ddc34c545c35c19520bd5e525ebd7"
    sha256 cellar: :any_skip_relocation, big_sur:       "0cba8f1f5d11dce2d4c2e65e7608eb5fae3250e97dc4aeaa1f27c9558748e02a"
    sha256 cellar: :any_skip_relocation, catalina:      "6ed0d8518a6da8ffa99c405be0ee4213a74dd78086e85aa12473094a64863f07"
    sha256 cellar: :any_skip_relocation, mojave:        "6b7f99a0260e8740f842d178701ffe9dfd81c0d279e92bfa43c0f982933d0543"
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
