class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2024-09-23",
       revision: "1301e4268f44e404f0a5847ed72a0b4879e253d3"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ed52707f1633e700dfc10bb4906b74209f6960da3e2403c6ae11e7afd422957"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "109e3c823dfe82b6e7cbe50ccda9d7266662c46fcfe83ed7ce68ce56d6c640a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a60681bd1726f9877a70cf4e4b6d3ca9aa016377387e5c3b872039b1c2d441c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e508b251a7f5e6adc53129c4aa0489c593e5d8fa89e9bd0e5f1b25eb20e72b99"
    sha256 cellar: :any_skip_relocation, ventura:       "e9c41cd1a757a203bbcd520800464f796f020b521929471b2fe09e0e25f8a301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53dfabe63616d22170a1351bf1996c323fa4d71c18438b8d5602fc344d9561b5"
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

    assert_match output, pipe_output(bin/"rust-analyzer", input, 0)
  end
end
