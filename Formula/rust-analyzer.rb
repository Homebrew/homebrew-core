class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-08-09",
       revision: "5664a2b0b31403024ce5ab927760d630d5ddc9a4"
  version "2021-08-09"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3ae78a16fa8b3833eb2baa366302e1bd83bd0aa37aec808369538c2458289cc7"
    sha256 cellar: :any_skip_relocation, big_sur:       "21ff589253dd65369e210844d3f763ccc4fd4e2e93f80c4860a581dc76c8f698"
    sha256 cellar: :any_skip_relocation, catalina:      "ba7b87fbbe51c0f5b4d577b548aa65ec8588952f67b2e35c3efe5e9549eba94e"
    sha256 cellar: :any_skip_relocation, mojave:        "4d9def6e30d56efcba71c7fb9eb24e74b46464a951035abf1af99da3994f472c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc081b14d7a03d15cb743fbdee8e7e4c64acbf1ec685b6cef40f39e343083ff9"
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
