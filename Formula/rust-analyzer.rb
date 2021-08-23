class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-08-23",
       revision: "996300f4a061e895a339a909fddce94f68ce7d19"
  version "2021-08-23"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "09d995071671a7441ba3de77c7cb286e76185e35a537873fc748697ee4d3d11b"
    sha256 cellar: :any_skip_relocation, big_sur:       "41da3e9d727f78bf76e8ad2397a0b8c854e29c55ff0c8bcc7a69033db32eb1f2"
    sha256 cellar: :any_skip_relocation, catalina:      "91dcb1371956c91236c31f28198c8eff4da1875e13e2e5f164e0d1d62c09120f"
    sha256 cellar: :any_skip_relocation, mojave:        "9e4b2b69e65e2ccf714a338c760db1f936f1740ba662fd52926f0cc3438a2a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05c83ddfdc516df14067fb88876be64e5dff50c6cdaf655f3f4e295c7cafbaba"
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
