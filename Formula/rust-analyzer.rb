class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-10-11",
       revision: "ed4b312fa777ebb39ba1348fe3df574c441a485e"
  version "2021-10-11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f620e25a4aededbb8663acfd56b80d929b4fd19495dc748eee8e5760296d2f6e"
    sha256 cellar: :any_skip_relocation, big_sur:       "76fe9491d39b5df43be9bab6e0f65cd39c7ecf8291194f046b44bce93872ad80"
    sha256 cellar: :any_skip_relocation, catalina:      "651d2d2d168e24f5688aa186ecf5642d2ff788ff15ab06c31d748200a1d7e86a"
    sha256 cellar: :any_skip_relocation, mojave:        "1124c79fdde460470dbe3cffc8a5056a1c43cda984453df1d07e2f21cce4c471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe89f4fe793263cb52a60a782605df517d373eacd6d3bafc1643fbb441c79a7d"
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
