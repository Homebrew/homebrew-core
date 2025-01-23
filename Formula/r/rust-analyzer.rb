class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2025-01-20",
       revision: "248bd511aee2c1c1cb2d5314649521d6d93b854a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a34908ed4e039cfd351dadec60b1c89ce6bcf8cff59f7b1634c2791183a54a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3801de0f05fedcf39e3a10ff86d28d68d98f9d2db5d47eb38e80cec0c3d98a36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebac63ae79190975cd668791c0b124ff113c2970457285eaf126a3fb500484ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "68f23cf1cf03ffab92208901a99d0cd41d0570be26a183caf49ad884cfdbb20b"
    sha256 cellar: :any_skip_relocation, ventura:       "288ba3df9c49aed6caab039b1c652f3d1b46ca2a4c6408da6e8598eaed6d5b4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e159b5760c503f4f04365fc9a8eb50683d5f203eb383d6feaee7121eeeb1b723"
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
    input = rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id":1,
        "method":"initialize",
        "params": {
          "rootUri": "file:/dev/null",
          "capabilities": {}
        }
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"initialized",
        "params": {}
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id": 1,
        "method":"shutdown",
        "params": null
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"exit",
        "params": {}
      }
    JSON

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output(bin/"rust-analyzer", input, 0)
  end
end
