class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-03-16",
      revision: "90c8906e6443e7cee18cece9c2621a8b1c10794c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d29f5186fa433f8f5884b77a770962b3313c7375d2cf1929ee9dcb22eb6ab15b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaefc78d6df7d3b68411bf27311aaf47259fe4642903d8ca24d71bab941a09ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad621180ec9efd4afba9392376cb0c4aabfbfde118a83e47a4b3df43891c46d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "49a9f8d3039d7ecb1c22ffdff773c775c0d7d4a4c235dd59d2f3dc37b2527771"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ff4f08b01300b87181ed8cbf7c9c9921f457c24b097cfcb56f3ac22c993a0f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae8e46dd75904ad076049f845689c3317ac9087897470af20e19cdbc7a38102f"
  end

  depends_on "rust" => :build

  def install
    cd "crates/rust-analyzer" do
      system "cargo", "install", "--bin", "rust-analyzer", *std_cargo_args
    end
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n" \
      "\r\n" \
      "#{json}"
  end

  test do
    input = rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id":1,
        "method":"initialize",
        "params": {
          "rootUri": "file:/dev/null",
          "capabilities": {}
        }
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"initialized",
        "params": {}
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id": 1,
        "method":"shutdown",
        "params": null
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"exit",
        "params": {}
      }
    JSON

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output(bin/"rust-analyzer", input, 0)
  end
end
