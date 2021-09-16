class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-09-13",
       revision: "516eb40ba5b9d20e59e98185d1b2fcba5599ef7a"
  version "2021-09-13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0e413b3fcd244e1eca674189f48d8ad5df31f0f25d2e05c4541082236d71a1ad"
    sha256 cellar: :any_skip_relocation, big_sur:       "32c0e6dec4b25082e30cd01225fd4f50c853e31a0f78bce1e01d08063a09a64b"
    sha256 cellar: :any_skip_relocation, catalina:      "497254e6af6c94e5079aa39f267bf7f6db41fb1c713d270beafed06b6065910e"
    sha256 cellar: :any_skip_relocation, mojave:        "5e8263b373343154f421cfbe5a0841e664a2544653b19375584bc33015a74ae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "379274b6453e861df6170aed4b823cd3437c449d64cca334eef194e66c598b61"
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
