class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-04-12",
       revision: "7be06139b632ee615fc18af04dd67947e2c794b2"
  version "2021-04-12"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8c96368f4d55a4f9e9ddd7140fb405549fa6ea1e00e6ed94ec2934cb8f6a47de"
    sha256 cellar: :any_skip_relocation, big_sur:       "0b37a37a5cdd1797ec34adb6194737bc7e0d1b8d56c0685b95a8e44f81b90499"
    sha256 cellar: :any_skip_relocation, catalina:      "d866f23136612bbe0d8bef30aa89fe7e0083152ac0e06897b13d97ce7967a326"
    sha256 cellar: :any_skip_relocation, mojave:        "38316fbb1114717b067acf419b1400f5f0ef2359981e5e424b39671a906bdb19"
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
