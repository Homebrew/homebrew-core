class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2022-01-31",
       revision: "fd3942eb620e37a4e4bfdd587d8a2893ccf6fea0"
  version "2022-01-31"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c5a6d5743ca4c50e69eb215b99183506f348d5340809756295485cf92bffaef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89bf5e8debc0827e7c8ed5d8ccb293b0249f12fcda9ce3e69a2bea3f5d64b1ae"
    sha256 cellar: :any_skip_relocation, monterey:       "8fd70309d8c01e3d966861b7e476278b5e4f50e466c0b757941fdbbda700984d"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf853b14a718a2d67929d001cf946edecca9391ddc1843031f721754fb2c8d18"
    sha256 cellar: :any_skip_relocation, catalina:       "23e18394cdcda09dabed086aac11c052296d35e7c9871a93e4930a1ba604803b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cb7d6396739486cb4576175ba1758124f413a087c7ac67346f843b556e84d6b"
  end

  depends_on "rust" => :build

  def install
    cd "crates/rust-analyzer" do
      system "cargo", "install", "--bin", "rust-analyzer", *std_cargo_args
    end
  end

  test do
    def rpc(json)
      "Content-Length: #{json.size}\r\n" \
        "\r\n" \
        "#{json}"
    end

    input = rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id":1,
      "method":"initialize",
      "params": {
        "rootUri": "file:/dev/null",
        "capabilities": {}
      }
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"initialized",
      "params": {}
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id": 1,
      "method":"shutdown",
      "params": null
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"exit",
      "params": {}
    }
    EOF

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/rust-analyzer", input, 0)
  end
end
