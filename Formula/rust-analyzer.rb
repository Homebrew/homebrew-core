class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-03-13",
       revision: "f1e51afa450ecf352c1f01fc5a5b6d10792e3779"
  version "2023-03-13"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ff4683726b1d8e29f7c62c765a8c01fc64f490cf9341486026dfe3959e55766"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9b8e9a0a7f956332ef26851ab4eabb71c94a0f94ed9e83117fd0c2c65ec95da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58fb692157f04376420d0a335af125d272ba5dd93c3760671f66daf50deb72bf"
    sha256 cellar: :any_skip_relocation, ventura:        "8c0dd33dfbfb3704523aeffe604dac32d16222db8a3a469f75a1e659d29ebab4"
    sha256 cellar: :any_skip_relocation, monterey:       "d20811dab27c4e7195e0a89742178b3fc00d9a184cf6888a31a7f7e27269b793"
    sha256 cellar: :any_skip_relocation, big_sur:        "227b195afb4b8e7997c7fe2437a2256e86cbc7ca99d77fe5aa28a1faa8dd1fa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "400439e5e849ebdf14c4e02199fa7c187125ddaa67cd0f925d4d13d0fba918ab"
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
