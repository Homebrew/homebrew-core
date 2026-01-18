class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-01-12",
      revision: "d43c6362439e7e4e515b83652026758231af6cc0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac677f6de88693bf48f292b446a3f1ad3e96108d5d73d07409380a5eaa13e291"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "670f8ee7918cae6804c699250e8177705e7ab1433fa9cb5f5784b6ec90c48adc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a24d61b031495c7f9b9e6ec9b99c1ab540f77767ff92fbab475359b6ce993be1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2be0ba5aa2ed0655f9fa8127f97be7cbd257beb680713d9be5c319c5752446e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1eec69942fa7ac58787e2c7bd7051f2aab3354ab78e90de3a806e06af343c05f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4f8cf76300628dda10eba89c58b50a65ce0948dec9edb1419949d75609a020b"
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
