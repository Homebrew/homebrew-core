class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-04-17",
       revision: "bab80dae445fd576cb4cc22ba208e9fbc39dc18d"
  version "2023-04-17"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4db1a66c3f05cd92dc616f2f98bf863b7d2f7dca3a97d10a6be250502b7d0285"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d31e7c2d5af895665c90a6cb934c165461f276e8590b03c98787ca91c06b64f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "681d513554e27f762ab4951a677ba33e516cd0c1f278c4d900279ab86a01cdbd"
    sha256 cellar: :any_skip_relocation, ventura:        "f047348c0de3ce39402215f71284eb23e8a20a49e2d3a50f6ad7872a51ef9749"
    sha256 cellar: :any_skip_relocation, monterey:       "3fe759cea4d69b0eae8494647e8ad648d011fa624dfd246a0c41dc0c5bf0bf1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "997f940c8f00dc405fae1f65d43d177b9c319aaaa5dd52ea56329b2c8308095a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a93d959b3955f7bfb9906d0c4cdc378f24e7c15ffbef2892b7e824e645d8efc2"
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
