class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2022-03-21",
       revision: "b594f9c441cf12319d10c14ba6a511d5c9db1b87"
  version "2022-03-21"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8de0efbbe18d036bd4ad03ade9e30cd8b425e9cde796adf926a00c1995dae01d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3dadf0ea02a2a167fb6eb04291302daab2cfc68a4afb44b5082fc3d46f33fea"
    sha256 cellar: :any_skip_relocation, monterey:       "c04a5e3e516b6f133f3c6380ec6a71c8ddcffd5e0c0e1eeb071c9de317b7cb07"
    sha256 cellar: :any_skip_relocation, big_sur:        "310c6da0f2d80f3782525b4a18b238255680e2bb20ec21784d475eff05490b42"
    sha256 cellar: :any_skip_relocation, catalina:       "e7332b8095b773af1913d6fea09e8e59bc84a1831651002ed4fb28a3144ecdea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5af7629bceee18b55678b1ba54ad493d2d87b10b64737e11b8bbb8a69a528a6c"
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
