class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-03-15",
       revision: "5ba7852cf153688d5b5035a9a2a2145aa7334d79"
  version "2021-03-15"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b0a2400e88a51f0a8ebec700347fa3dbe48347dd7596c810908e8a3cf3afa4f6"
    sha256 cellar: :any_skip_relocation, big_sur:       "dcfbdf6490b1a9de1f20e1aac6c4d9b4818da0aa6bfef82183fd8dffe3dc4501"
    sha256 cellar: :any_skip_relocation, catalina:      "bf50b28ac9f7b97921f4f4442ac1f7af5e6a1d873c2c3f8dbb8f9fe409a204fa"
    sha256 cellar: :any_skip_relocation, mojave:        "3ea04f5e4d81d8585e58291bd83d4b0ae47159c6127d98028e17096c4e38dd60"
  end

  depends_on "rust" => :build

  def install
    cd "crates/rust-analyzer" do
      system "cargo", "install", "--bin", "rust-analyzer", *std_cargo_args
    end
  end

  test do
    def rpc(json)
      "Content-Length: #{json.size}\r\n" \
      "\r\n" \
      "#{json}"
    end

    input = rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id":1,
      "method":"initialize",
      "params": {
        "rootUri": "file:/dev/null",
        "capabilities": {}
      }
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"initialized",
      "params": {}
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id": 1,
      "method":"shutdown",
      "params": null
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"exit",
      "params": {}
    }
    EOF

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/rust-analyzer", input, 0)
  end
end
