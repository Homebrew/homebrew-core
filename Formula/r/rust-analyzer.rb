class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-09-25",
       revision: "862a3004e958082d0e9cbdf1172c5fe2bab6cf2d"
  version "2023-09-25"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb6f3ecfa82d9422280767d72effb1825a53c7ea50e6eac25d49ae1fedbe371c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9acf5ca57bcba84a417792bbb5a41592afde0167d7d35f5ff4a91ca273f0044b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4b3cbf20544cbc166f2f5ed5b68837168ce1336ccf9da71d9ba03a0b523d664"
    sha256 cellar: :any_skip_relocation, ventura:        "ee33d1543c26de00ebf024edf39dc5cff7cde3d6603da74d5cb34010e495e167"
    sha256 cellar: :any_skip_relocation, monterey:       "b6f2380992a42d9bd54a05dbd07170eed1f4271d9899ff379a0a28b7a9dd3883"
    sha256 cellar: :any_skip_relocation, big_sur:        "6752648b660cd32579d20e6bbe3dd1cc2ac7125cf745d114f7c3d4a7ac0515d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2da9cc2e7092493754231306db2bd16f626413d961df00e799828142d6543e4c"
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
