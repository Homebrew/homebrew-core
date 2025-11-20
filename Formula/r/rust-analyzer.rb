class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2025-11-17",
      revision: "2efc80078029894eec0699f62ec8d5c1a56af763"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a22882ccd0c5149cdb62a0447a14e8f0ceaacef76750f788d4bbf83c01b1ba29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6a1a462e18e9ad0d9936fe5a198c6459fe14faea9cd2d7fbc38090d0b2f9f31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fbec2d95aef90c8b1c58229af13cdebd29c64ae0cf4a7fae0b4db969b695d24"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5cc2d65bd9a58d94120f2d0467cd9c8ad87fdea457cf2eff3f12f1550ed6f7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c3cc5d8acd09e629bd8ab8437f0b1e374c25449f00981f289153c30252bf85b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1d1c373772c4ec399dc462a1bccb99d2becbcfcfbd6dcd1744ef437d474da88"
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
