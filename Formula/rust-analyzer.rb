class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-09-27",
       revision: "009e6ceb1ddcd27a9ced3bcb7d0ef823379185a1"
  version "2021-09-27"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "95ab47a273b48124a0bbbeeb9c625425ac04c3622e83c1ef17f52185943e2d93"
    sha256 cellar: :any_skip_relocation, big_sur:       "1ee0e238b22fe095af31d50db74fd3625b28a79c462e38351cd76f2b81cdcce1"
    sha256 cellar: :any_skip_relocation, catalina:      "eca2a71e0a508c4718295960fc82eabd40a7c8c05041ca24b0e1d1b572903fcf"
    sha256 cellar: :any_skip_relocation, mojave:        "67155009fc567f701be570cca4aa2b13045824f85b108fa81d094c2c1501edfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e89a68ff8af09a3c1883289c13c0a55bf3a5343f2431a5df72dc5082fbcceb1"
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
