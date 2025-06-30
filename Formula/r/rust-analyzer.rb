class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2025-06-30",
      revision: "6df12139bccaaeecf6a34789e0ca799d1fe99c53"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c368a91d885fe86ee11c88a9e6bcf34e9a53be465230e9d44d2b6e61d2a1bd1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14c048b6387627a4af3a466cfe1ee8f7d3eba605efd5b3beb3c5d3461777756c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b95c57d27d7537b834a45fd319c830db49e0570ce786a4e37a18eaab359e36b"
    sha256 cellar: :any_skip_relocation, sonoma:        "82bed943c88a90759aba8702aced43db327eec18b2a9ecee44bea21d448eb659"
    sha256 cellar: :any_skip_relocation, ventura:       "19dc420fbb86b4d5f477efd5af848b1a2196fda63303d0c6752c7347e1b2d8b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db9f3edbe304f7ba1b4b7784d858067d5039418e85bcee98362e7c99beb1f1ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f73525ad0bc03f9c435bee15785dca86aedf244242bfe3f7cb0e26e460b56ee"
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
