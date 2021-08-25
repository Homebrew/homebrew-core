class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-08-23",
       revision: "996300f4a061e895a339a909fddce94f68ce7d19"
  version "2021-08-23"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ab27a08bbe894b831dc88857b07d710039609360e67e8cae2765991528f4e913"
    sha256 cellar: :any_skip_relocation, big_sur:       "78ba12f521b9baf683ad5ebb3e686d828666cd8095dccf3aa48c2559445b6d8c"
    sha256 cellar: :any_skip_relocation, catalina:      "22793d8aeb95008b09dff82bdcee9c62fd118d67315dc9bce76da58b5fa74025"
    sha256 cellar: :any_skip_relocation, mojave:        "d7143816c95cc9e3a4094a24c3c301dc59e8c9deef29faccdf931d66f2029341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38bad93461f14e58c9cd96f3a291888ef67b49c07d2c9981251ebdbb80a9e5b9"
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
