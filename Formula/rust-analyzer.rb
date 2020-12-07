class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2020-12-07",
       revision: "a0fa522fdaf25daff6a2a9794214f0e0bedc5c24"
  version "2020-12-07"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5c26bf0bc6896653c21cb21dcc83abc2becb54d407272386ae7be3c039c6894" => :big_sur
    sha256 "eeb3cb275eccbf5fc71053c142e2f876e0aac104337b255fbcbda36f708bcf21" => :catalina
    sha256 "6ecd79c4d907d1321c1d899a5f1d90c2300cd5e214c8ca18207ff01ffad40b3a" => :mojave
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
