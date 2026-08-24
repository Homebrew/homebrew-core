class WgslAnalyzer < Formula
  desc "Language server implementation for WGSL and WESL"
  homepage "https://wgsl-analyzer.github.io"
  url "https://github.com/wgsl-analyzer/wgsl-analyzer/archive/refs/tags/2026-04-26.tar.gz"
  sha256 "ac422ae9615bef7f41992eedcc0aeffde80cead438c2913ee254bbbefaed0511"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04bf199a21fc13f544db18475328738dd876fd13cf43c6a0403dd1692b6cbfb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4ad72a0f22c366f5ebddd6e10165e7cb4d2b2f7e075fd52c5226a6abea4ccff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bfbfeb776b318186072d7c3a4cf36a0f3c58e1399eb0052aa297cbec992c45d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a937a93b03395cb02c9e4b10a9e786f7caa4e630637143be509159e08ce3762"
    sha256 cellar: :any,                 arm64_linux:   "c398c8d3a5cb8d8e9424c67f8380191eda9350f9b8962ce035ffdd82928b9761"
    sha256 cellar: :any,                 x86_64_linux:  "17bfdab7ef126b99b0fda29dd1ea3222fab2f683720358e444862aa33a7911a2"
  end

  depends_on "rust" => :build

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
