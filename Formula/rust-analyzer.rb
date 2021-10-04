class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-10-04",
       revision: "4b7675fcc30d3e2c05eafc68a5724db66b58142c"
  version "2021-10-04"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fa794d0cad59c0aa2934ed3657668898f53715ad46d7b0a1a51e23a950acdc0e"
    sha256 cellar: :any_skip_relocation, big_sur:       "49703788449dff5c12baf22ba43f5f49cba89eaf335c036c036d1553fbef100e"
    sha256 cellar: :any_skip_relocation, catalina:      "86ba23672a33d96bd3b82b79e98b9d4f731be7ba88911e1fe810bae7dbbc2201"
    sha256 cellar: :any_skip_relocation, mojave:        "398c53745f8511340c1cdd6c52423665c3a5358ff746b211e1b3b2c676a00845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec86abbb8e1019a2c7c795cce6eb539f4ec1f10fb1aef8905f0f3b95ddc9b0e3"
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
