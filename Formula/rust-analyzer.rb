class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-07-03",
       revision: "ff485b63bfd9a44ab2a0dbe88dcf58b79496f1ac"
  version "2023-07-03"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a29c8156bfc75adf942fef7c042c404373d289025d2da11f8037db1262c4b0a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fd4bf6e3c42e13b2a39f5bcd92cbcb178830276822e776bb4dc947955a52194"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fdf4cd8aa12d2413ca02ff5d2b5017d2a80f008875c1306b2a00f2e8ff8ee04"
    sha256 cellar: :any_skip_relocation, ventura:        "5d711abcedd6861a312e4406da32728507b6f35ff3fdd74df0487e39eab423e4"
    sha256 cellar: :any_skip_relocation, monterey:       "d519df6edd7804ef75d012110e43fdd9e85ac6deded6b9ed632a62812a4728dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "25fad5436130b06e41eca32a285b9b8ec7e569e8bf57c8ea9b3c964b35d5462e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ce38fcc1f4c12b4933724f3df4d192a3540c99acd9c8ea534f28283b0118495"
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

    assert_match output, pipe_output("#{bin}/rust-analyzer", input, 0)
  end
end
