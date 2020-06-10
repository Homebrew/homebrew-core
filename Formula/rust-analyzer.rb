class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer/archive/2020-06-08.tar.gz"
  sha256 "fe0317b8dca42955784a443e763c8e86673ef5bd555d3440c1590c89b8a3558b"

  bottle do
    cellar :any_skip_relocation
    sha256 "9aed3ae9658ddb965f8bbbb95a7c28006e624ee2aee7fa22ea0533ead2be1147" => :catalina
    sha256 "a427cea76cae3f8149e7d2f7969ea731d4f194556642a37688d181d29a1463f3" => :mojave
    sha256 "ecb8407952329b892603bf03bb4f2137b24273ecf9f9e91b90a77c4cd8189e21" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path",
           "crates/rust-analyzer", "--bin", "rust-analyzer"
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
