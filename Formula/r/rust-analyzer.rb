class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-05-11",
      revision: "e266f5cab8f6525d0bc2ddccc0006418c534b5e6"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa57c3020fe9a55515240526cf4a29c69cdaaa442f8ea18ebd549a52efb3d8be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4839069b4c97cf3a7d3b23d766004c51fbca53fe27275b387b1bad93c432993a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eaf1220410596055e990efd371e245182df06705713936b3ad054a8fe8983983"
    sha256 cellar: :any_skip_relocation, sonoma:        "65801360dbcd435c3d22f493689665919f74c0824953ecb363caff28983b379b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43fbd7e5ca551bed0233d6821c7160c66e925163763aa9332967f3c46c8eb3f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0d3342cd3dd9338c76b5f2e6ad5a44b486aee1ea0e8fce06550cfc1c3fdf196"
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
