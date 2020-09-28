class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2020-09-28",
       revision: "eb79c2094f4328088b13a3dcf5fe253806c73c86"
  version "2020-09-28"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b9c59d8bc5f39aa4e7e494a9cf66127cd1e947d43bfbf0aa2e3d4ce9664b43e" => :catalina
    sha256 "ac0faf61560fd516ef701a08e124e59cc2e37dd8df99d25de96a4b63ea1dd2f9" => :mojave
    sha256 "1890275241b792b0806065bf7e73420a47a0a4a1ab4df17c76cf44780fe14ceb" => :high_sierra
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
