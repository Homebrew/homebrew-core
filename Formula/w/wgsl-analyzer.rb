class WgslAnalyzer < Formula
  desc "Language server implementation for WGSL and WESL"
  homepage "https://wgsl-analyzer.github.io"
  url "https://github.com/wgsl-analyzer/wgsl-analyzer/archive/refs/tags/2026-09-30.tar.gz"
  sha256 "656ca21fc1e37bc8c1bab25c434b315ba910d4f6702ee6905e20e9860e8f482c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "34bed1ecacf838bf87438076b5861512874281dc0379063d159d445a35cc4cc4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "845e9c529d8fa7a4e9eed470696bd8fa38bd37a2d4c2286579dadf6d29368111"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4f738f7e27f9de4ab7a09fc011ce10d7c280b6fae245aa4d4f1ca736a59345e7"
    sha256 cellar: :any,                 arm64_linux:       "5c4f9d58f493035e81c90f08eaf873b7ab6ba358ca9cfadd4a3eedb822f18e8b"
    sha256 cellar: :any,                 x86_64_linux:      "4bf8a18d111a68339fe8ce500827425f3519c9d23eceaa3b65a6aa4895b0c5a6"
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
