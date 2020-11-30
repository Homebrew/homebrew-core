class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2020-11-30",
       revision: "ac30710ada112984c9cf79c4af39ad666d000171"
  version "2020-11-30"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5cfdbb5d0c8de4784a8ef77644c23d62f6392fc102eb29725a8e741579cbcab0" => :big_sur
    sha256 "e0d6e355ed208b7743274d867d5156a53177f80745c9f166ccc394bf6f2092fa" => :catalina
    sha256 "c4ab976541218ae1544211a06477210d0aaf9b75c5656d4853e4423219834b29" => :mojave
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
