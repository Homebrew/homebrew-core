class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-10-19",
      revision: "5ec20d044dbf04895877a55921ddc0ae6e73e127"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "73161af70f22366e192b3bd5dfbdad99cd72d357dfe9c4f5cc9e1441edbc71a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "55779b98b41da3f4aa88071ff9def08fbd99b5d17d5bf4b1d1d8fcc6af264cf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d5f74ad8a40957e56ea4eddefd3c143a57578751e6a4b42c888d835c42f80de2"
    sha256 cellar: :any,                 arm64_linux:       "71ffd185d8d020823343662088a319c0ed05f373c45a3e852b65a929dfef3a63"
    sha256 cellar: :any,                 x86_64_linux:      "2b9fb7963e275e202db80aaca3919d4d28b24ac60e70da7554e24df763f2cffe"
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
