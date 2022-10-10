class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-10-10",
       revision: "61504c8d951c566eb03037dcb300c96f4bd9a8b6"
  version "2022-10-10"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "793b1a2ca91b6787a025cc0583229b2ad4f5b2617e28d642a01ee330af72908a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24475da08e579c37d304878445f72018c848bcdd3aecc5e79101e8470f8a60a9"
    sha256 cellar: :any_skip_relocation, monterey:       "63367a1e5d681b57e4160c72c69bf78240ae0464eb49aa3e63e2781f7649b3d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fdd0b2784994f0846b7acf3f68eaa2e6a8fad1cb56f04861243087e2f639651"
    sha256 cellar: :any_skip_relocation, catalina:       "8335ea94aaee5464ed00630ff7f05050970f52c8c627f55b2bd4467dccaf6088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b2ad2d517dca4515385e1f4b0261f74866b66aa40b687832a25be2a7dbe840e"
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

    assert_match output, pipe_output("#{bin}/rust-analyzer", input, 0)
  end
end
