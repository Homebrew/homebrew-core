class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2020-12-14",
       revision: "dbd0cfba531c21de01af7b1a12ce9eb6b1271a5d"
  version "2020-12-14"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea1e9c2cbcfadef88d194af359b8d426524f855eb7974212eac237ae2efdebc6" => :big_sur
    sha256 "81ec764be770e9d3781e9f27c2227766723811682304f34c5fcd43603d0e7ef7" => :catalina
    sha256 "72cb730b0b3842b199cfb65dabb0c4023e3f159a0606a6989179edfd3fe1d4e0" => :mojave
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
