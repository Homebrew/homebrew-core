class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2024-03-25",
       revision: "6f6b03f9de783f91456080b3f6adc8d92903c1b0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfe13bd1f704531993f29ad7c42b16c878befa82f1856dc52e908dbfa9167362"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afe84ecd37449ef20b983f3ce2df9332567da6ce3516a00b4295ca80e7f5424f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af1ad525f4fdaea3271ba6f676783f5c94459582dc2ebb9d6ec9558c2d8aac92"
    sha256 cellar: :any_skip_relocation, sonoma:         "89eabba37d4550284b7cad32fc2132361d02e440018ad28b83e7e8e8d8aaeff7"
    sha256 cellar: :any_skip_relocation, ventura:        "13b1fca870ad2d270e246f46d93ba0a82938a8857303639d29c2301850b8b4fa"
    sha256 cellar: :any_skip_relocation, monterey:       "f896658c6bbba36dd7e74465395d6ed81f05ba404efcdea15e2d09fd83f276d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09768a6562a40f3a7b7199eefb95e5542eaa5e50c373c295d5327360c66a4b64"
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
