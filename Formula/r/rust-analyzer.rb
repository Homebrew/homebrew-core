class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-12-25",
       revision: "85fb463fc586594925f05fc8e285b1568f98f41a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61c085de0dcca6d1042ba12c9267dcc8fa863a314aafb1bbede72bd05fdf49ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb894cd854101858edce0376658a8ef4e13ae66e8a02ce8676f3b2c45dd27c91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b940f17de930d7fdb396d14dc84c87d6bd66856381e92a9937359f13d31801d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "a006b2b333a4ad62484e2f80d4903243d7873d955f567d3cfc868b90170dfe17"
    sha256 cellar: :any_skip_relocation, ventura:        "f9f071e9d4199c691e5d0c687c9c4bb20255f45af5faa8e15cd7552fdb893f69"
    sha256 cellar: :any_skip_relocation, monterey:       "a03b535d0e94bcce81fd7e4e2319228840c84120bc356ce3d5dc29424999fde2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba5488790de86e2fd31cf9a21bab642e2f1580816365399e4c72610e4139f071"
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
