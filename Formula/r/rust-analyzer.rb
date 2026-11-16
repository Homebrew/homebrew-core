class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-11-16",
      revision: "946b80a756ac1a1ef8882ec65e4f3199e38a23c7"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2f03a183c3bf9003bf633f30c6f99008f93ca41e7cde18b824c49df667b2e80b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b0f971cd6a768b66858a92ca75384f1255f6be8dc71c9cc2ccfea314f4d99c95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1ecd48a54e88941adf821de9450af21b298586b00483eea406310776b70e2082"
    sha256 cellar: :any,                 arm64_linux:       "b774cc56309e70f1780a3f8979c57ea107c00d74bd3086c3c7650f26adf53c04"
    sha256 cellar: :any,                 x86_64_linux:      "2c67586b773c65cb6ffd7b74f85afc388e8c44f9c401f338401d86440b5b9de1"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
