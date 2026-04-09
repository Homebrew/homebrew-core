class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-04-06",
      revision: "38fb8f92ac15853d7fa9fb47fc2d81fdd5cd6c7e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c3e46b4877001c67680069bf9ea2c41579ec234a9470c0a277644cf705e37fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e264f958125f028b0e884dd81db044aa7e90e1ad7ff35d086fb662757298521"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1555f2e5602e05aa15b1044b0e86c70da906646a4949e055bd1a947537618217"
    sha256 cellar: :any_skip_relocation, sonoma:        "af78a0a0f999148d0f2ede023d435d18e234fa04c695ab2ad27ba8dee2634f73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc683226082a14ce13658221290882160423e8668c5983e458cac1333c8d42f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73bc4fb3432b523faf6dd2ea765465a43125f3fd1c15e7e6fca36fe9c3cf1963"
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
