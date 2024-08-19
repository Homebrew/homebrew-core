class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2024-08-19",
       revision: "fa003262474185fd62168379500fe906b331824b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6fc43be4af6a910ffb4871d181d6c0fb8b62490ee0dcc28ade747434699626fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56ad1784a30d1a05555f00ddc4d5e36edaa0f90bcf7a8824cf4828529a1d606f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8c8616e3fc5e30049216f8eb0dc841c66cbf6d5da61f056dd332847e4d91257"
    sha256 cellar: :any_skip_relocation, sonoma:         "93a91b450b518b8f68748ddf9f79ef257c394c5071959562f18a9ed0a7646d0a"
    sha256 cellar: :any_skip_relocation, ventura:        "75dc2fd5116aa8043468d4f306bb67b5abed32e18775c9a9bd253b59719c7f62"
    sha256 cellar: :any_skip_relocation, monterey:       "c7d7ca5f566b8077a1ddbad0a10a9953d62c993a1d58eead10a92a1c04339fe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59e5e19e7af8d8abe4079c8f60f73885dc07454272a677ad0d542175e8f2452f"
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
