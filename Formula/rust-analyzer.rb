class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2022-03-28",
       revision: "bc08b8eff3f8e4da7c448d7b7f6461938c817a60"
  version "2022-03-28"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8530f14cb322cbe5e70020649328ac0ee7fae249c328d2b037a1b7c459024db2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8589451503c7690b8b176ded6d973c061e8e377326b80bf3fdd3c8e047b071dc"
    sha256 cellar: :any_skip_relocation, monterey:       "3f0840909ffe2a5902eeaf32f56185a5b78f34fe449de864a6cc04e91910cac3"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6ad3a84160fbbcc576dc9aa4d72e7aa830026802b5f86798aea9ec56486ad4b"
    sha256 cellar: :any_skip_relocation, catalina:       "966bf9efc867b0ea54ddc635c81f5b860e7265a022b4d83f61f5c5a56ba3ba39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b275c7e8f378eaeddba1e9b93cec207d2a83f8045bd0c4c735331d786eeee70"
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
