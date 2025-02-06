class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2025-02-03",
       revision: "f3998f7f8a197596c5edf72e937996e6674b423b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df48e983e12ae929fddfa67a79e3bb6cbae2a51c02a32bfed0e4a15ca71fa55b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63a6e40d74a84d1a91f18840a7817a7ca05134fc7db96df2518ba4b196dec3f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "445c6e1c042d7c33c4c1f7fdbb7076ae314476bbe4dadeb585ec2e8452d5b698"
    sha256 cellar: :any_skip_relocation, sonoma:        "98c45e57db025f68182d4398cc5c170372f2bf5e2b836bcf317e618175f55975"
    sha256 cellar: :any_skip_relocation, ventura:       "2a22a5097e3afeeb42a6c2e093463d03da8233cfc343699d43abf3230a38b74f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39fc4b65b1fc9598ed3edee72338c26b1324a0a8103749c2a300cfe2c594f369"
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
