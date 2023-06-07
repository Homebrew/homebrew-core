class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-06-05",
       revision: "2f1b7cedcf5044ba620646c6758bbb99f46b8d95"
  version "2023-06-05"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e216541af017edc0cd6f5095bb8c192bb28e2cbc62ac0e2941166eb8efb0833"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a77748b6ca15247870411b0c3aed82580f8decb3a67f1d5c26bfede57ea0ba2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62e361d6c6638f73ea4bbd2b6019efb695eaa9a44d99daecd3ae2bfe72398749"
    sha256 cellar: :any_skip_relocation, ventura:        "284d74b0bdf0f7198f001d9931b1cac4483cd518464eac2d953bbb3af5b1d426"
    sha256 cellar: :any_skip_relocation, monterey:       "ddcb01777a93e29d9dbac19ef7e2a287cc9dee5eca44b29a6d9651d51772477b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3db6f0e62804d1a35228a149d9b3defaef9060e6e93d3f410f0d66e2b988b160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fa63a1a4fcc82f30131addfbfe1713b67a071eafeec1899ec62452963e074dc"
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
