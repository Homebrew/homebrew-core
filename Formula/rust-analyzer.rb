class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-07-05",
       revision: "e5c1c8cf2fcfae3e15c8bcf5256e84cad3bd3436"
  version "2021-07-05"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8e8f62e103429c088877ae965328640fe351c0a04f83662627305b7401e1bfb8"
    sha256 cellar: :any_skip_relocation, big_sur:       "5d6c00aa9bd4a337e860001b19e672b7a9bffb8be58fa5720e3a4d852a2e9611"
    sha256 cellar: :any_skip_relocation, catalina:      "c6627fcd9916903b5862fa60d35b7b51da62192b8015920748c74e9eebb234d6"
    sha256 cellar: :any_skip_relocation, mojave:        "b21ee83832734b62b48c474966721e35ae1b2296e3993e3d57845b31fe02a588"
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
