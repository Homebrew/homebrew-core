class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-08-01",
       revision: "2b472f6684bb1958274995d12b2c50310d88cc52"
  version "2022-08-01"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a80559812288fdcbfedbd1ffbbcb17825536686cfa0d756ef2c2ad7ef35246d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56efa68f92d77170955aced4e099325f6a06023b7a2e5dbea83b1ec10a3cbe8a"
    sha256 cellar: :any_skip_relocation, monterey:       "83e6ce75f257bf3dcf9fdc52df8695639e014ec8829ee30e36bd84cd94925b16"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ee794c960d64d25e65fef558372a3a198fddbf3d53bc34d9168815d3b82e3de"
    sha256 cellar: :any_skip_relocation, catalina:       "472a4d213f2443e1d210103e8d47f52e9af6f5f37d9172667f43afbc9e8174b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "056df290252c538d14f02c2e356bcebc47c343fb1f6cff283c758259a194c7fe"
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
