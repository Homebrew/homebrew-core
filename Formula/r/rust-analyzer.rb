class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2025-07-14",
      revision: "591e3b7624be97e4443ea7b5542c191311aa141d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28a20047bd716337e560815b718235fe028ad0b88636c975c033b425b3c55d68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87592590b2eb93977766450dbfd5a311822a1ed6b2b409df596698f486f3930c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "218b35c378a97569382f80e82b40cc3f07914ed0b41e27ec6e2f7c5c49d11190"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c55b9fbf734a74cb821e8e7c079179b2311585f528524c063811c8ccde63e85"
    sha256 cellar: :any_skip_relocation, ventura:       "206d4865f06d5242c5ba4a0dd94d69351b3b3fafabf1e54b896344772e269cbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42673b834eeaf9d7ec79e9f3d4cd8fc541079f6fb73547d8c1592cb51ff4c8e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85225dca81630212b24bda176190f7aec1de9a35ff008f9e62a762392c622c91"
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
