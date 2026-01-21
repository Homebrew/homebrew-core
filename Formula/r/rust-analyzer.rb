class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-01-19",
      revision: "080e70378c543d26a3a817899cb66934ba76360b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb8cc7ac7e72352de1fccfc369cf5b68371381f807bb266b86cf0b762bba500f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69fb3bb57c91df026c132ee45685c999cbde9ee479fd82db9ba3047f652acb76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f335993d179a4875012d5c0a75b8ba99d2ee448fa6cbc1a46967139fbf584e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7995ab82b995358f55b1f7205e6e9f5ffdb2041ed899165824ed43d1bbdb9f80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "911a329beb38d1898c7563fb9e4990a25b0eaf4860ecdd7e76bce5221d057b43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1b768425436b27318f6096ebece36ffbe9d7bbe973e5875eb38ba5edf3944a6"
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
