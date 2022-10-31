class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-10-31",
       revision: "ba28e19b7838e3ad4223ae82d074dc3950ef1548"
  version "2022-10-31"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc71c23cd7f0cb19be135cd2c0bd38a4d74eb20788e61b5bbff43db4fbe155d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7619d1c3716940f2d79c49dfc0008856013a78752289d7f28d0369b254e98951"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99067feb6c6887a687c1c1c659f7a5e27a69acf7ac2824353fc2fa5379056af6"
    sha256 cellar: :any_skip_relocation, monterey:       "c0e326d5350a79e6c1dd53442fce29a7f1afc6a35c0dd7c7229d5741db4bd51d"
    sha256 cellar: :any_skip_relocation, big_sur:        "11dde3eea2b61b394633205802b04fb63fbaf3a7f9955aecd8ac643b0899987c"
    sha256 cellar: :any_skip_relocation, catalina:       "c12fab31f10516ee4079fce0a07dfb3a4beed38e2675a756ac7a8eb79316eddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d3fa66831d7e45f6d402c2053fa2a6a9748de051dffb974f39e5a3de1a52c92"
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
