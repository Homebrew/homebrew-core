class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2022-02-07",
       revision: "ba330548023607717295f0dfd61b72eda41aa9dd"
  version "2022-02-07"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0939fc7eef74d05ba360da7499338b2789b3ef9cef9a55be41e9088c1c698b43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0f6b437ca4869c8b5825d98f551a5ec9aaea10d1a1d589ee16c65f2f5e90128"
    sha256 cellar: :any_skip_relocation, monterey:       "7d3ebb63a30820e629038f949c3d8b12f598e8ecd21f5d2bdc3c522f21841b7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "83f3ab74682678eda6b596a71b756971292d58db556d24ec21e5e21634663312"
    sha256 cellar: :any_skip_relocation, catalina:       "159898e362dc68503dece348e8206b82294631c60f37f2bcb3e1661901759a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ce584503d883872d62ea69d2e6c492abb028352202bd1ac40f3b1252cf2119c"
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
