class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-05-04",
      revision: "f04c37286472e3687a2d32d3d1fad2772de515a1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68a7442fdb9f8c024a872ed38f2b2008619f8ed5fd926307e0d1d7829f040962"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3a59439d89dd33a7e697be48f558ab0800b0f7dbc10eec9a3b9f3600d9d7e05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7960ebda5e687d70fa7bb714eb20d79b918572131613bc4f1f774498c8c32ae7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7555e90a078ef1e454fedb235a33fce6e19c22657710162a30b109465d71666c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d03eae32ec623b59bfa5a047b7821220838836c8ff582cd65984296cdc80b027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eef10ef1968867086761954d67fcd216f6f095bd6dbee0c0f48dc9f5647a560e"
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
