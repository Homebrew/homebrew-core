class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-08-01",
       revision: "2b472f6684bb1958274995d12b2c50310d88cc52"
  version "2022-08-01"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9951b7768642b00360eb78121a825d82835392864bfd1aa51ce242b06890ed48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1faa8a42d07f0f6b04cf67b0a529d905b32e399f78529f597856a9b75fa3b565"
    sha256 cellar: :any_skip_relocation, monterey:       "e8a9ba1132c251641c8c4945f8c509270f2199c0c0a666a3e91b3945cadc44ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e77e7202fa6607b3a8618a26aa44569f849616749ce12694e151c1787baf4db"
    sha256 cellar: :any_skip_relocation, catalina:       "2efb4ffb963236775eb71c455500d48c93f817d723ac8a62bf3d50e01e088483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "264436a2c793bd8897815afe1b6dd25c61adad963d450e9b30f1c6f69aca79ac"
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
