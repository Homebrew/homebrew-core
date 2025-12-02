class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2025-12-01",
      revision: "d646b23f000d099d845f999c2c1e05b15d9cdc78"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e24f709172590546127ae4398b67cbc8f180c47bd255a21d4128fe45bc60d766"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e20ac6eb8b70ca3538c7e717c3459dbdd7a0a1b50c956dada70ab9288748581b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "accf6250e7bedac853c9b180940f52ea5f82b70048e2d760cc11ce3c889f7811"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4e65c23585271b704657d01d8829671f2ed698042d04e5c5b364b70f0a5a805"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1137806718476932e77ab8a4ca9bcf236f1e03f8d4d5431e18b41b02de81cd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a792cbb758c62449efa3ddf933f4360abc2f765e756aa03fb4046262d6e261f"
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
