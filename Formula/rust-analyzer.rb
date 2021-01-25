class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-01-25",
       revision: "3ab8d7a9ae1b8c5e421a4666f6693ae7278a7a3c"
  version "2021-01-25"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff3fd4297cc80163d964349964b78c51f80ffd037244d2046ec0764949709b5d" => :big_sur
    sha256 "8ccadf8af8981799e541912c84c0ad1720e439559ab57555003db6d1daf5967f" => :arm64_big_sur
    sha256 "c31aaabda9cea832bf8b10a7faea8e47e54c99375f535fc6eb3242c3165712d6" => :catalina
    sha256 "bf652095477c6c545f5e46761b2d62185cdc84e7544be128f60c0e317f41c486" => :mojave
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
