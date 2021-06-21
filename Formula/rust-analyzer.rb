class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-06-21",
       revision: "3898387f3bd579c0c5415ecb7c7b3d3923947f2f"
  version "2021-06-21"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f3200efbc5f97a1d42c0e6d8494960ccf0a42bb600cf287f3093a76df22667f7"
    sha256 cellar: :any_skip_relocation, big_sur:       "c7abfad5b5448b46e61640c2df4bc77826d88694a51be8aa29f0db5cc5ae3e3f"
    sha256 cellar: :any_skip_relocation, catalina:      "706188784f3b9c319c3e0a91e2adddc224b3c2a13ea375c25512fe402f0a1d0b"
    sha256 cellar: :any_skip_relocation, mojave:        "996badc255572cd9b99e906a508c8a52848ed91c401b7534e726b49a8c499843"
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
