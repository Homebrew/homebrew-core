class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2025-08-25",
      revision: "6b2e677795722dc95b9b5dbd2f38ab4e0cfaafc0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a60ec4a22fa224c5ad646c8ad1d947911da84350b33e9fd52c2140c00ee307ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31641bf19bcc8fbe82c8c551a2affe66525a63b0ad85e31d17c5e9a481dd521c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45b4dcb84fd93c3e4c7f9ec41b075723995c4ae02c8d00c1e5cbba1b59e53b42"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7fba4f87971c38cea6831e119ac86b6704d44561ded696f790c61af7fb066040"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a938dcf45658302d849227caabb6abebb6a70d05450555019019da664c659f0"
    sha256 cellar: :any_skip_relocation, ventura:       "dfe207e4902de8c5b3526d2db71052e6a809fe1dbc363be1833ad153f7741555"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4631a30bf3d683c4be1b27cde12f5231b080b8ff3226a14596811eab689f0c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d911c3ce3909565a8e8237e73426b2f51357068eae2a1df9fc36e198112a273"
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
