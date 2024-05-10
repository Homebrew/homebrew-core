class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2024-05-06",
       revision: "c4618fe14d39992fbbb85c2d6cad028a232c13d2"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53c807558265763a2b2824353b03ae7121cc15b1f0cdbec6410fa2860f1b5342"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38e1f1a670f79e13197fae5e7faf6587ab27777f3e509a0a500708549154109e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa90c17a24d2b92d456ce357fc0752cfe13d147cca6ebdaf59f39464f9b14366"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f59592624c2b7e9db23581994ea66b4e1a597ce820589b105d54afa5c203f7a"
    sha256 cellar: :any_skip_relocation, ventura:        "7bb2334e6d4e674098aab316db97c1f5ec0230738ea76a0d26c7bd1af73e7137"
    sha256 cellar: :any_skip_relocation, monterey:       "7b33fa18bc0a6826f329c4599ae31ebc84d14e27929968a0ca111e3328c9d6ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af2923662e5bd5c1d5c6eed86c8255238d490a811ea5792fa755016d68ae2d8d"
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
