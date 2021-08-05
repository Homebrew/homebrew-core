class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-08-02",
       revision: "df0936b4af7bd573dc8906b6dbdbf80ff40b75f3"
  version "2021-08-02"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d4c8196ad3f5064cebcb9ae2258c12ade63094f8532321503b8cfb5c2b92405e"
    sha256 cellar: :any_skip_relocation, big_sur:       "747ecd8538dfeeaf29f65bc351d1f7e54e74892aeaaf14ab322cb1b911f76506"
    sha256 cellar: :any_skip_relocation, catalina:      "cd686bb83df32c9d3c5255df07dcccc6efd7193939b690ef190aeee92f26c8c1"
    sha256 cellar: :any_skip_relocation, mojave:        "a294d5076e368454772fe3e9bfcd18d78f0c5ba2a7c421c0bb39687529cfb890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "712f06e2dd4001de2e0b90881ad87c91eb5cba8ab1df5c1ad57798a477e50b58"
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
