class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-01-04",
       revision: "5b86ff3e91838e58397ec39502d85056e46fcfcb"
  version "2021-01-04"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b639787a5df90b7d7106f95db70406b95681e9360a2c1022214b5e06c54de437" => :big_sur
    sha256 "8fed3dacd63368d3e251a4bac15418ccbddab4ba73478fdefd8402164b0f8e80" => :arm64_big_sur
    sha256 "4a60f0104596ddd7d56d2cfbcc406d8c07cb6696ae0e83442252f5dffbc2044d" => :catalina
    sha256 "c57c00d7ebb86506d1c8d221947efc371fbb9cfbf0f78971650f31a11fedd9e1" => :mojave
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
