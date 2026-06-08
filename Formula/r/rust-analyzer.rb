class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-06-08",
      revision: "7ea2b259ca3fa0e97d0e8e2ec4c3f902f049cd76"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8719e24b6c4ee9af0e80894fc3969c6245929c231e73ff4d5097d0da63658788"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5f95bca4d293e1bc25494e60c535b2c0addae1281135cdfd3a317626033fcbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4af5e9086dbb82011d0dbd30f03d1af93f802059a723ce6655362ada23a03188"
    sha256 cellar: :any_skip_relocation, sonoma:        "00897616c8a1709b711b7bc9dbd3c36aa9a861df96b7b349e792169ef5186205"
    sha256 cellar: :any,                 arm64_linux:   "60d82071ae6fbaf1755cfa3782f30841943429f6f682dcd57f32f82703ccc329"
    sha256 cellar: :any,                 x86_64_linux:  "071970ddda0e5ff48e98b65e42a8983ee792033df4149f2becdfc1bf15adfd6b"
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
