class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2025-03-04",
       revision: "02862f5d52c30b476a5dca909a17aa4386d1fdc5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95a512b32e712a6e25907d2b6ebfa1458faa638a30cab73e160be77f93943755"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be790af03731bdae70094fe4e581a56c5b6f325ac0cda38685a52cef986d1fd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "829b4e085c489195e9b07da38c41e21c1ded768713e33a6b0626d9c0ba66484a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7787407bec56dd6101f066307e521084a26d31eb6472ce335f8ebee78bee9a6"
    sha256 cellar: :any_skip_relocation, ventura:       "204f1ddc2f6a1af231ea6f1a40cd95216d25a4edf41ccd94468bd3e9812d463c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "255cb4c20399491d47581f2cfee4da6b5a945fd6d120ddcd3f5ce19824c05587"
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
