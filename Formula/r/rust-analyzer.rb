class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-06-22",
      revision: "69ccffdb5b3570c6c14c5780bf2e8836f2209d90"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a78f05aec018c27fbe5e78e24d3511ef971c23f6dcd224e687511709183a3e81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23a81b842ad03664db4f3b3d9f0968977904fefc9ae0d0bdc54142bb7c734da1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abe7a789b58703a533ec05c22b5739dc57fb5e2fb50ddfcc07a69b7a9f6ef295"
    sha256 cellar: :any_skip_relocation, sonoma:        "676761eae98fe8376da80002c776cfbaac2b394ecf82942d285643ebcd2875d1"
    sha256 cellar: :any,                 arm64_linux:   "4ea2f5831eaafc89cd3ce8592dcba9b4b33bbcb3b28d1b165cc466f9c414675c"
    sha256 cellar: :any,                 x86_64_linux:  "6a79c64587d496f00d0321e9fb96adfbc2d796929dd0ba573daf2c342f70d788"
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
