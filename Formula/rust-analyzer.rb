class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-08-15",
       revision: "b6d59f2bb4fae0ba4f74e2c967b5e2f777f8c860"
  version "2022-08-15"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9453769bd69049b6963fdcea3a60542f85e71680f8bcc729f2b536e0ecdfed25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4bf9312ad988ca3c24cf888f2ed77df2fa51aca25e4630ea1a22023b0b00d75"
    sha256 cellar: :any_skip_relocation, monterey:       "934560315fa9e784e46b6cb7b6be04dc25ff351240c0bf1ea9e43fd901f9d49b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d79e4e097c4fac8f1a5171a7fbe3b51fd5b99295fd8df89b4bf4301a8737c7c3"
    sha256 cellar: :any_skip_relocation, catalina:       "4f93c87786e5b7ff9d38366268a42c2a48f8e9b59a11b34de473f51b567fca31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f477d98fe3c2abbb40433f320db35a1dd597ea570010cda6e21495567368014e"
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
