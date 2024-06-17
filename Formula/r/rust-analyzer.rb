class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2024-06-11",
       revision: "c86d6230fef10bfac76bb79a721ac99f0eb7aca0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5bed2c6e4e3a15e8695177d2e384b38852e0b2d640c20db44bf2a89997195c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "218464b4c08f82eca58ae8ee0b242968cc624bfee6fe1b37656c9d41ab712eae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "678420e20bedcc6b7b747c02177997a0e776faa1ca3b6749f58176256f734246"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe6bf1086da41b5ec7f452092259ac9928a580e930cd6c3555327742d1e223c5"
    sha256 cellar: :any_skip_relocation, ventura:        "d871e765d6c73e7f82d66c047e8cd86e969461a481d9c23c760137648c5e2058"
    sha256 cellar: :any_skip_relocation, monterey:       "fb1becafc7ca8a38e5edd49fe0708374cf505084e35a4fd4ca458ac01585f5d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "222e1c7f587cf3cefd2546c03eadea6922f7803458264d81be293f2923e9db33"
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
