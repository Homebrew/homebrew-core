class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2022-03-07",
       revision: "5fae65dd28b450a437ebc800a410164c3af1d516"
  version "2022-03-07"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d559a9bc5da8ddffe788e8af54eb8263f9740db0c72321dd8ade075482634c30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12340823df93c802ac05ab9b56ed74f4212023b72acca1a201a26495349230fd"
    sha256 cellar: :any_skip_relocation, monterey:       "c11701adbc2373e6f0704c909b305e0f1eeae95de0b7bee123f819c919f931a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b95387da73947fb9fb8e2427c1aefbb2c3b3bf6e2b061419440b651cdef9fcbb"
    sha256 cellar: :any_skip_relocation, catalina:       "9fd4bb5d910bb51006804a44ce22f3a02cef2455d46b2d60347aeae7e474dd5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97b3a09301a97ad3998a64f127a1f7b0819bc000afef69f4a8db716dcda8b9a7"
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
