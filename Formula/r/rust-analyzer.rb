class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-07-20",
      revision: "cac0779549328e4bd4b808000c03307f1721f869"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a980b2e3b5628342761de5844a4d08e29eb698dcaa7c5dbc5c4b586ab1fcba64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "904cc58e66a3a2f080ea6ec231cbb7a33f69da566c281efe9fbed317c7420656"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e799a15368bda4ead84014a15ae8befe9fd38a48b9d379a215b9c7195d00f335"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5c4bc571521d2c722bafb1c864ab36272634a6fb2173d68102090fa27a54de5"
    sha256 cellar: :any,                 arm64_linux:   "a3f47352b02f7cf7be5d11a46b51cb77a846f407ac7dc8ea743f5dcbda2b69b2"
    sha256 cellar: :any,                 x86_64_linux:  "276f11d47462ab6f60c0d405404809e276c65238b745852eeaa6d5ae76729504"
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
