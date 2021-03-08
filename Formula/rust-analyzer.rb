class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-03-08",
       revision: "d54e1157b66017e4aae38328cd213286e39ca130"
  version "2021-03-08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "24fd57d3c388dbf378d6b393aa92118533945dc1bd1f3f950b2e81f1cf296569"
    sha256 cellar: :any_skip_relocation, big_sur:       "e94917f59270f00c6a8c89c60224ee9d3dbcb2b4eb4b6730ec1ca61d33da823b"
    sha256 cellar: :any_skip_relocation, catalina:      "221ca7fb124237bd50150abcbdfb0e48be0427fa3945c490b919b05aabf9943e"
    sha256 cellar: :any_skip_relocation, mojave:        "e823a5c4c1cce3ab32d743d5877a5cec87bb33a9886a577c63aff943b553b7fb"
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
