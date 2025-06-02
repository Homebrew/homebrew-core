class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2025-06-02",
      revision: "2a388d1103450d814a84eda98efe89c01b158343"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a46aa937a451244a8206ceafb61bce2b5fe421c836ebb27a76ff2dc6af9e07d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c244ad8ba7c6d4f69d1765462e9fe78cd474dd611f145fc54fc50e3466919260"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6cbac1922be75b6ead1dc2534e82ec716ee558f52e419bb71555f87779d11c88"
    sha256 cellar: :any_skip_relocation, sonoma:        "15ac6aa81430ce891324d0945ea96bc7702f9a011a32e12325c90f99cc8f6e67"
    sha256 cellar: :any_skip_relocation, ventura:       "cb4899fda36302dab030fa3674d2b28c8ea842c544a624c153b192ced1688a29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09ff247cf6c801f3b35cf02045d8e8c04eb1c53e22003c4d785dd582bc803698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bb8d0996c7af3ee1226e2bf21893951bba5732766acca402d9260836259986f"
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
