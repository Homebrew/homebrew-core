class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-11-02",
      revision: "b98172d80f0da12bbde3d6733c274e17cb6417aa"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9cbf3c181848764ea6e3e0a8ee5f55494342bddfbec97c93423d649b4d0e5a25"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e26ad175c0ad826cfcee21392f050b0a2ecfb5b6235d7ad4a707890a1bf47427"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "97fc246d1d89f00efb63f9dcb7e5dc197a7a8e34a979090cb95823617c2db3c5"
    sha256 cellar: :any,                 arm64_linux:       "212d411189de41c24c40c2bf91b7a86e5f9e1ff483d4cc4cab30feda3be598de"
    sha256 cellar: :any,                 x86_64_linux:      "c3fffb3b83acafe778c63e3798cd9d2aac206f594bbdc56e01aeb91cf799a21f"
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
