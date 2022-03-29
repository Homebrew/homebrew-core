class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2022-03-28",
       revision: "bc08b8eff3f8e4da7c448d7b7f6461938c817a60"
  version "2022-03-28"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53ef9a43ebecb461c0840e7fbee062b252819974162c3bda1ca8d12c18367dca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7558360e68c35aec473b95da81b68a735b75daa2e938c00c78979e777e3509cc"
    sha256 cellar: :any_skip_relocation, monterey:       "4aa358cbc880670650ebad0d9138cee60d9105c8c18c1bc03836775d283fc716"
    sha256 cellar: :any_skip_relocation, big_sur:        "c62365a1778a57a62c60338dcef43680677723d5fd46701b343bb3f6552365af"
    sha256 cellar: :any_skip_relocation, catalina:       "d46cfbc1123adedc43ab41ae48d9ecf02301431709ccbda8e062ccacefeb7f8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d32470a629223bc407b94a949ea9017bda62f46446ddf3eeb65ac2c3b6f7cde"
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
