class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2020-11-16",
       revision: "e8c803937ce23a6cf74583ad03f9868869c7eea1"
  version "2020-11-16"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "da30ca4cc3dc440b5fb8fc5358b14d0483d36f93c178d23bc298416519058913" => :big_sur
    sha256 "e451c17281769cb0599f54b2203688f6aa4972e3dc8e3af2be923b7884b8b5c0" => :catalina
    sha256 "4d6b5af88a87cedeb52b99aec09c31f77561145dbe0a0269334052ab6fd718a5" => :mojave
    sha256 "be27993f95041e17b3a26ac24d424e47a30b34b0954eb56d7d235e8ab522b646" => :high_sierra
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
