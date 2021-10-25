class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-10-25",
       revision: "1f47693e02809c97db61b51247ae4e4d46744c61"
  version "2021-10-25"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5e57196ef9af906a7512d7268a20ff3f1ce81bd9f45303ad90947274bd9cad5c"
    sha256 cellar: :any_skip_relocation, big_sur:       "e55e1a058437c6d5e60231476e021c09ae25a04660298c57875ff539c550f1f0"
    sha256 cellar: :any_skip_relocation, catalina:      "8d1a0561221802694a7ea8d320093cab879c856ed14284ef35e1289a2aae57d2"
    sha256 cellar: :any_skip_relocation, mojave:        "e91c9fa30b52896aa8f5d99e5958216895bf08191db26d7f7e19f8e51d19d476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "592cd83ed38a64bc4f29b003e2d1a7e360caa1272c87cf027d0050eabe8657c2"
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
