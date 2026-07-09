class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-07-06",
      revision: "7ae18ed96a90dbb8972fc886321651fdda80f7de"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d05005632fcea6b53cc9f79ce3a51bcea05859466b97ed305782f96ee8071969"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bea139efc01b2f3e2b20eb7fd40e8c6f29e7b15dab3bb80fd29c3abfb40a147e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ce30bb89505b94958747b4d1b66cbc68ac1ee17091758646b1bfab0071cf902"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b81eeedd57245173cb12aeef37c286cc1dbdd0fbfee7fd1719b4d2ae8e93867"
    sha256 cellar: :any,                 arm64_linux:   "2287619c9ec97bdcc730391d3935df5294ab0ac2e2db1a1d706d2198cd609eaf"
    sha256 cellar: :any,                 x86_64_linux:  "82a592696326e1743bed15ca281d51d4fee67fec05676791fe44333785c69183"
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
    input = rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id":1,
        "method":"initialize",
        "params": {
          "rootUri": "file:/dev/null",
          "capabilities": {}
        }
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"initialized",
        "params": {}
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id": 1,
        "method":"shutdown",
        "params": null
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"exit",
        "params": {}
      }
    JSON

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output(bin/"rust-analyzer", input, 0)
  end
end
