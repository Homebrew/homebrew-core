class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-07-26",
       revision: "5983d3745ac8490c1c2798fdc963aa9fc803dd03"
  version "2021-07-26"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c33494df0a44659ee22e21a9050571108aca1368d18e9f72c21b8303ce181d72"
    sha256 cellar: :any_skip_relocation, big_sur:       "6a9903a1513524ff24acb4674a22404c79e1eecf5ade4c3a649fba931c5f5c47"
    sha256 cellar: :any_skip_relocation, catalina:      "904396fc6b88527ec89dbe898810ac8f69a1c1768934d35bc60395743bb4d592"
    sha256 cellar: :any_skip_relocation, mojave:        "18787e81f6ab177b205d95e23fc5a02da2eb44fd575b42c1866eff7bc2ff5ba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0532a3b1089a2ba1e11dbd21232d9cd31159e1d19c54d95bb402aebbfc876539"
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
