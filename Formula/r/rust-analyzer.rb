class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2024-04-15",
       revision: "5dbe3fe75c584aee2063ef7877a639fe3382461e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d29d516cac9180c6bb5deab6effb615e8e07e5fa0a2997c539b830ed49e8ab1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cc3426f373a4b53462fb8bd4cf3298e852d15a6b796b06b3d81833fcf9f2e9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec2bc72cdf5beb17dceaf61b50854860d0358dafa75dc795047f8aa664487ac2"
    sha256 cellar: :any_skip_relocation, sonoma:         "000a157a2f391419be6a0bc8abd122850fcf82f7e6f8b01145b92d5b3aba7d8f"
    sha256 cellar: :any_skip_relocation, ventura:        "58c37f199c71edab89b63667cec119cedb3987de6a61ad9f24ea37756fc24371"
    sha256 cellar: :any_skip_relocation, monterey:       "8f80eaf645945c1e7a715428e21063c80e89f80fa85d7887a9728bf51ec284d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ec15e80c6c9b5c399133def3da85f5ffe67a56a11f670ff886adab3e78839fc"
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
