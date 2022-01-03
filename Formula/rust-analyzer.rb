class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2022-01-03",
       revision: "8e9ccbf97a70259b6c6576e8fd7d77d28238737e"
  version "2022-01-03"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b1f015fee445097c3fcbe8eee389b67b40c7a9ead6edcfcd8c871971b19e5b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b5864a051e467d02265027337778e1464ea5cc92b858ee79d4ef2a4bf136403"
    sha256 cellar: :any_skip_relocation, monterey:       "dbc67100a93d0b4d84789576e03856960d86e90a1d5ef7662a12cf41886f3a05"
    sha256 cellar: :any_skip_relocation, big_sur:        "494716f1bd5ed687286b2248deab0d5d1fbd06ae85c9af8725545c778503c60b"
    sha256 cellar: :any_skip_relocation, catalina:       "b586efb17098eed6f03910002456260c0d9456cd2dc011abf20c942c267d055b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17711be00263c8177bcc0ce1e104515068c3cb65ced3803d6f558999ca93f13c"
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
