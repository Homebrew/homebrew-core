class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2024-04-08",
       revision: "8e581ac348e223488622f4d3003cb2bd412bf27e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d06d2b380082f7abf35f30e92bf1159e54ab91350bb96e4bc257576c19b6d9c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8ee254135211f166ef2a4f7012a05c2c97cb56e6904c1a2de9648a15a29a723"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be7b7189bbffa76d0857ce48545cd39ec0be1e02effe221f68fba15623df082f"
    sha256 cellar: :any_skip_relocation, sonoma:         "38a89a516047111fd161a55c765bf38b3a203fc3c8e2c85f1f592e2114bd4da6"
    sha256 cellar: :any_skip_relocation, ventura:        "2c89deb4135ebc7e9cbe393d03bec588795e0d83641bc9842f3a6c11ca1bbeec"
    sha256 cellar: :any_skip_relocation, monterey:       "c08702bfbc6760d99c96f467c8b7b5f68bd6d7b243347096a72fae0148260b0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd979c0b899bb5b68d5e29aa0319bc755f1d31d7961a172ac05f7ca634181011"
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
