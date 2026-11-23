class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-11-23",
      revision: "37721d141370e0904033f7fc3a3abe11c446c4c1"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 1

  bottle do
    manifest_sha256 "2e0d621b7d0f465da0f70ebfa75b615520b769327cb02353e0672e6898f8b9b7"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "013ced7f6249dcd3ec9aab59b7c615c6d8033bacc10eddde76bc2513e5345219"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4e2bdbadadfc2f60f83df4d2b2d51b4e893668b82f02bd065edd5adcf29f9343"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dd561decfaf042d12bc6d87f50fd338fc5b8532c284d1acb396b234638478dd4"
    sha256 cellar: :any,                 arm64_linux:       "6e185758360ecb1b7b984cc48acc9670bb0888c56c725562839559627666e533"
    sha256 cellar: :any,                 x86_64_linux:      "6d6a45f5a86aeb852f940bba24fd6e8bc1f3b5bee9f1c8674fd3ea68b7f59c70"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
