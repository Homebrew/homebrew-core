class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-06-14",
       revision: "f0618a8f06a464840079f30b3e25bcdcca3922a3"
  version "2021-06-14"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a40eaa064caf15da2b549b9945c6e7102a6d06ab5112abb9dc9cef186a22fca7"
    sha256 cellar: :any_skip_relocation, big_sur:       "d286243955688823ebc15508d6a0e2a807e4b0fe4f49c0addf8588595f08f68f"
    sha256 cellar: :any_skip_relocation, catalina:      "bcfbf8dd8abd6bf0eb7aac9bca87a82f9eccc444fb95755dcaebe8058037558d"
    sha256 cellar: :any_skip_relocation, mojave:        "eafbe05dd0e7cf967fd6ecf558c0620dfccfd8678a88cbc0a2a4a6de4f71ed82"
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
