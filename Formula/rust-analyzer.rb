class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-07-18",
       revision: "897a7ec4b826f85ec1626870e734490701138097"
  version "2022-07-18"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "416e444e03c9df26c4831da77c81d2ab8eb7e652bff03d3890e40444785e156c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "552169eaabe5fc81997c8edf3780bd44bef9357c427c39e5d02d653315814e4b"
    sha256 cellar: :any_skip_relocation, monterey:       "a9a822ade1083c8d3db3b4d99ef2f4336faec573512bd785071146e30f7939c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0662c8bedead3303fb6bc0c0f7d1c30b873c68c73f59d36897649601c1922d3c"
    sha256 cellar: :any_skip_relocation, catalina:       "4253d852f33f533e02434463e8eea76199e1ee245a934303eb9a06110d02baf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00c5609e30605545bc18d298f0b87fc0522de07b508077b45f2602bd8bf02198"
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
