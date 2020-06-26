class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer/archive/2020-06-15.tar.gz"
  sha256 "8d964ba82fd4d34287953f9654c79b5a4b2ed7ca0c710759ecc1d9e7d76bcd40"

  bottle do
    cellar :any_skip_relocation
    sha256 "84c4d712170b890a2ae67bfc3ed3e0c6afae12e0b8a65e20a1209f134592e11d" => :catalina
    sha256 "59fd6cd2d4fed794ed0d635b3f048bfe20a4c6ddb44d3fd4ce7f649e1578bb91" => :mojave
    sha256 "b16b5d0193d85f89f6249b8063730779e7e039c6635b08392d77c7dddc9d47c7" => :high_sierra
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
      "params": {}
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
