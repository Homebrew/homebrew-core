class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-02-15",
       revision: "7435b9e98c9280043605748c11a1f450669e04d6"
  version "2021-02-15"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8669fea0a3e01b6b4322135e128b2eaac4a595f4fe3f16d7b179ed3b49106cee"
    sha256 cellar: :any_skip_relocation, big_sur:       "2b5bdac6b6fa83d706048df8c8c2895084a46980ccdfd48df7a6d6fd467c9a0c"
    sha256 cellar: :any_skip_relocation, catalina:      "e11f2cb019a2d894bb86e633c38ae45a4d2a56450f5a56f9778ceb84722e00aa"
    sha256 cellar: :any_skip_relocation, mojave:        "6ea7ce3dd364296382be08e2cab88f7eb86c217c76ba085e7ca3ffed02d36f73"
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
