class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-05-31",
       revision: "f4383981249d3f2964f2c667f3349f8ff15b77c4"
  version "2021-05-31"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ff3aa914e7b21ed8e2758aa75af7d70b2cc09354d2d877644a903d5aa3c6ce08"
    sha256 cellar: :any_skip_relocation, big_sur:       "a074b456d9a5b8b9aaa720634a08192f099147760c045c81d8c9f48640384041"
    sha256 cellar: :any_skip_relocation, catalina:      "32f2c5106cb32b34ad1ad832bd94e2729e6b84376a7c5a7a5ddb0b3d0f8dcf29"
    sha256 cellar: :any_skip_relocation, mojave:        "05731d6e44c7dccb8cb6982d7e4ddfca1a18d130f53c632176f507d9ffd72d99"
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
