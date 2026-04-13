class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-04-13",
      revision: "7b6e1249b7320e16792e31ce67bb2e5f4acd6a8b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7fa16eb4ee942f6dfcfda505d087e8b56fc4f98874912709f26d44af137ef25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dab6f4167b3949cc8b49f4842fa072855a62b53064a98a7c25d07766ec5b3bee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f25dbc70a54b89ce4f97f7ca2b27e55d36fb8f502522672753daa735bb0f00c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b1d62ea686777a94bcf70e6a87a36e8e33978380c92e9a90d49e1fa64747e09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "615b9ada54f2483d72a51e34513fc17148d8dbcfcf83885d7a1a04ed91e8095c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6657c533b536d98e6eb95fbeee89109f29b5f54ad0325e269287f2f02b9e4176"
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
