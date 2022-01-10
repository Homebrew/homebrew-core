class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2022-01-10",
       revision: "0f8c96c92689af8378dbe9f466c6bf15a3a27458"
  version "2022-01-10"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8773fa65ee8baa4f575a662d8ab679f20cd941c18c9c8f3f9a41ef65724a191"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c6e04b434f7807ad7a8196b8904d375657ee3b54d0fdfbdf25561f50c2d4cfe"
    sha256 cellar: :any_skip_relocation, monterey:       "3d453fdbb203951a17f2e4a22bc2f01c32b74906877a207bfb718df35827012f"
    sha256 cellar: :any_skip_relocation, big_sur:        "077b10985ee245012ea657275f1841451dfa2f5d9ed074a235bf878dbf4dad7e"
    sha256 cellar: :any_skip_relocation, catalina:       "5f9df9435b27de83e86d17ea4f8f58e563b4858c7808a2040c13f32ad8da2a2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a9400d57a9198e15a5a876e2d066c255a2fc8f51552df9b75c440298359c07b"
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
