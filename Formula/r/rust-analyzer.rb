class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-08-17.4",
      revision: "bb3bbbd9e4529cbf1a6392d5953f03eb01af3792"
  version "2026-08-17.4"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0adc43fdf09e81f624be4c5887a753bb08c8649649eb556cb85ef7a1da2a7c38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bde97c341bf8a55cf7d453713dd7008c835141fef5f615a93f5856d7a305792"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20acd55bc86ce9aee22530c3608cf0e2c4c621bfac5a5a3a65b2aad0a847066a"
    sha256 cellar: :any_skip_relocation, sonoma:        "17d884f47e9097c2528f141717bc23c0cf4a3617ce4e52c76ec43a210ee3ee41"
    sha256 cellar: :any,                 arm64_linux:   "6b774b8b9e133eea68747036014b309d395fea7a3050f1facf92c52ebb1a69e6"
    sha256 cellar: :any,                 x86_64_linux:  "018d3a54d3df9262f9c97c58fe7fb461c17936f45b837d3e026a36097275b68d"
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
