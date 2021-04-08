class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-04-05",
       revision: "19e09a4a54c75312aeaac04577f2d0e067463ab6"
  version "2021-04-05"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "77cab0c56491c3fea728468aed7779c56553cfa01d6964109c5949b25129788c"
    sha256 cellar: :any_skip_relocation, big_sur:       "42ef97af7139d2b252f2cc27c9801f535d64c281361125dd8b82d978e78ded60"
    sha256 cellar: :any_skip_relocation, catalina:      "455336fb209bad3deebc24da55062199c2f649f315ad83aa42ceb0bf8bce41dd"
    sha256 cellar: :any_skip_relocation, mojave:        "cb08d57d1bc3bdcb5f2fc8d4df32da875169bef95dd4fea3d3f7529f91897671"
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
