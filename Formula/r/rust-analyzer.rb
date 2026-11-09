class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-11-09",
      revision: "e5e7830640558e323e89c831488a3172b58dc66d"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cf025050f6ae09b93122b83f25456c89c06a535bc3ebfc38c112824bce9af6b5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f094a419feea87c32330892cddaa06a721dae20640529a92f094fc3003d8cef8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3f231638c75342211251bd3f8a1b6c32f8ce360a201e957d1a69a8a4ac7fc0e8"
    sha256 cellar: :any,                 arm64_linux:       "d726fd389217b937fdf6e57fd8672ba1e23ec156448f1d88e8ad491a3098770f"
    sha256 cellar: :any,                 x86_64_linux:      "88df72fa28b25c2040e03ffa30d6a89c13875a778d00539e0ab1589a1612707e"
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
