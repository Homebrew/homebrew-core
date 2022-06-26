class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-06-20",
       revision: "427061da19723f2206fe4dcb175c9c43b9a6193d"
  version "2022-06-20"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78813828486013ebae36f32e1532e567e2ae54b023df302ed4d954d5155814bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8afc652dedbd10f482d19ec99c05229d498151e08da4ce4e1287c5d4864e073f"
    sha256 cellar: :any_skip_relocation, monterey:       "e90c6b1de582cd725db802bc7b90975f41ea36bcbee831ce8a0efca33e89389c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bfd5c3471acda1c0d1fca384d43e406ac52566093e2fa068a8a72e37eda7d3e"
    sha256 cellar: :any_skip_relocation, catalina:       "83fe8a824f19f1148634376f6a122c0fa017972199cd6ace8253f34aba1412c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55b7fdc18d855d9a01c27fdddd853cf50f8a590b4115de56022ba6d3572bdc29"
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
