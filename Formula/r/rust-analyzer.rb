class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2024-09-23",
       revision: "1301e4268f44e404f0a5847ed72a0b4879e253d3"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24d2a048697c3050b3d4788c9afff0ba512daa6c2e2bded1ad360a208891c9a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "349485fe511712b491492d8f892e8b2a2e4f9fbcbd81373ed1ecdfef74561dec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d235ce952fbb9509c314964dc1fb496f9c55c63d637a9271cd0eec5e2cf9ef9"
    sha256 cellar: :any_skip_relocation, sonoma:        "93cfb7d5f072f6abc679a8f9019c35796abdc865c7b50a7457854eea4da22273"
    sha256 cellar: :any_skip_relocation, ventura:       "13632582e43a251569cfc2ae677b226ea584d276a060acb9d08fd5d989d56270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be0e96cc4d7301275b119bd261e7ab40586010c5a5f5fe25a1f8b95c2de50144"
  end

  depends_on "rust" => :build

  def install
    cd "crates/rust-analyzer" do
      system "cargo", "install", "--bin", "rust-analyzer", *std_cargo_args
    end
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n" \
      "\r\n" \
      "#{json}"
  end

  test do
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

    assert_match output, pipe_output(bin/"rust-analyzer", input, 0)
  end
end
