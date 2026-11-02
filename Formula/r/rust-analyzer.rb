class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-11-02",
      revision: "b98172d80f0da12bbde3d6733c274e17cb6417aa"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "10d747116a6b3ded48b4af518527d68e5033fc83254f769d4a851a259f2749d4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d43e98cafad34480ed901f8324a944bc3586627a87a51583836b74c5f170a466"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a90b58c7f6470e2016e1e4fc56af49630fbe085d577bd3b381810eeffbe2ab3f"
    sha256 cellar: :any,                 arm64_linux:       "456b52efe64f54b91effa985b061fe163fc7b9286771979b823b10e8cc94afc5"
    sha256 cellar: :any,                 x86_64_linux:      "898f83fe06ccda6d1bd92109aa0b7f69113ba7ba2587581b7040a3a2b6999c95"
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
