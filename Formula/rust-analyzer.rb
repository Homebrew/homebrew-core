class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-12-05",
       revision: "a2beeb8dbb5f4596f8c6f28a09c20355ea4c4628"
  version "2022-12-05"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9c956d2cc08fb5e445f1adbec92213bf1e2e1232eed691d514b91413f807162"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fa2fb59604337c94c4177cf10ec8509148861da8d820da23745e5bf3e19c888"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c7da570161588ab4f022ee64dc16a37252b9d0f1180f75eb7deda5ca58b85c0"
    sha256 cellar: :any_skip_relocation, ventura:        "179371caa72e657d8ec0c31347ef6ca4277548a1c082801fd69094870325a26f"
    sha256 cellar: :any_skip_relocation, monterey:       "449eeddb4761ff918f7d1a79d4f8907123ce261faddc3413ea3a82609371a98d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9aeeb5968b7ef67d7ea891810b496952dbe6996c5c56978ebf8f01c7ad6fdad"
    sha256 cellar: :any_skip_relocation, catalina:       "0ccb1034dc9d7b496af45f8e24d1b56c50163e253a2a57a9b122f2c7b316f855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5657b1fe50114a8cb369da376e4200db7054a4fd8938c152192ef4fc9ab7043a"
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
