class WgslAnalyzer < Formula
  desc "Language server implementation for WGSL and WESL"
  homepage "https://wgsl-analyzer.github.io"
  url "https://github.com/wgsl-analyzer/wgsl-analyzer/archive/refs/tags/2026-11-02.tar.gz"
  sha256 "0ef0ec3f9a2cc4dc90bb6323b3b851e7d287895304cd8aaa95bd1c39ac1d1b23"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/v?(\d+(:?[._-]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "65eacdcf243b6b59c9fd268022a08399f437d88a5eafbbc50eb27ad768a790f5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f8319716bdbb1731b13a2fb0e5899643b7a69d1905acd9c5d6002baac57d0fc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "694720f7476e036c6865ef72cdca653f1a0acc2eea92b88a401bd25bb2397345"
    sha256 cellar: :any,                 arm64_linux:       "9e7762d79037ae6b39816e383d5176e84a09e7b682a32d9eed0637199a49cac6"
    sha256 cellar: :any,                 x86_64_linux:      "e14a20b6f99d626142571c2d502fe56be777ad025a58380cd3db606fbe350f89"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/wgsl-analyzer")
  end

  test do
    input = <<~EOF
      Content-Length: 132\r\n\r
      {
        "jsonrpc":"2.0",
        "id":1,
        "method":"initialize",
        "params": {
          "rootUri": "file:/dev/null",
          "capabilities": {}
        }
      }
      Content-Length: 64\r\n\r
      {
        "jsonrpc":"2.0",
        "method":"initialized",
        "params": {}
      }
      Content-Length: 74\r\n\r
      {
        "jsonrpc":"2.0",
        "id": 1,
        "method":"shutdown",
        "params": null
      }
      Content-Length: 57\r\n\r
      {
        "jsonrpc":"2.0",
        "method":"exit",
        "params": {}
      }
    EOF

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output(bin/"wgsl-analyzer", input, 0)
  end
end
