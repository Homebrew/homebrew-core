class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2022-02-21",
       revision: "d6ed146a1caa41c65a831efbc80d79067c8f5955"
  version "2022-02-21"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b16b66d8625e18526958fa283976679b1218c0f9ad8e842d63525e4cde1b877"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "540dbb174fe0498a7a8949077fa0c791d461edd0a1ced5ecce92bd7c53f4a4ba"
    sha256 cellar: :any_skip_relocation, monterey:       "1a723e9c10908f38b385235a61b0979b73e6457fe74a12d8e5c2efc93e5bfba0"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cb598beb613da80a937eaf125a6eea9b472cc4b4a445ad254e745e1f58ab767"
    sha256 cellar: :any_skip_relocation, catalina:       "155462e43258c75ae4c7eaeb3b0b27145aa38f9f8bde80a13dcfcfeb776b084c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2e40e2a725d325fdbc867bc0441188251272f0ace40c69736762ef3b828a02c"
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
