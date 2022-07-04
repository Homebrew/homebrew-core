class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-07-04",
       revision: "75b22326dad1914c22484ab6672de5cae94f7457"
  version "2022-07-04"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a7b8d551a8a62d3f0d21ac4fe637fe3ccf26c5be09f007606a3b4a5e1de4e15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03a5c74a2c8fc3c4fc156bd0f3ca0f35706fba79c30fb1ecde1ca6df88c13ef1"
    sha256 cellar: :any_skip_relocation, monterey:       "0a4c8bcae7f263786114ae48c96eaf7130caf145314d580e52748f54b4bce864"
    sha256 cellar: :any_skip_relocation, big_sur:        "95b73b69178d8bff006cf41b8da9435c63a13caa4abb74f19ce55db5cd5f4a46"
    sha256 cellar: :any_skip_relocation, catalina:       "313047d7d6545bc9bb610d7dcc93f4c2f86ab8af61f100a16370abf6dec385a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2aa43bf10042c1a33986f83201837d98f48a3025b4f2001a998f78ffc1124653"
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
