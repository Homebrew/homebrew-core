class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2020-08-31",
       revision: "ac4b134c6be27642dbe915f32a41f9a21bd0c1c9"
  version "2020-08-31"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f135a49ff5dfc0642b4f0aedfb1fc420e280931ff6fd8b136ced703cfc97bbd9" => :catalina
    sha256 "e090038190f7ad0260d838a1aaf7e7fc5e384053e17377a6ad9c99e5b77a5f30" => :mojave
    sha256 "d261ad641fc8d160ad05b42e208a1edf9a7dca5b0210ad0a5b1e68a7b28023e7" => :high_sierra
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
