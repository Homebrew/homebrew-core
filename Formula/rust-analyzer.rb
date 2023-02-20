class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-02-20",
       revision: "a6603fc21d50b3386a488c96225b2d1fd492e533"
  version "2023-02-20"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8d66b9d590c2f28b7b5b6704f18bf1a0c36ffe84031c2d95b9a592ff49abebf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e8cb4dc3c31f13dbc1610d41f84bcbdb6d8b366ef8963bc778f56a19a62de9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eaba9e224a1b57f0831d30b14a1c33fe7271856dfa1a4c380473574c494ffa12"
    sha256 cellar: :any_skip_relocation, ventura:        "38f8949be9211e4f42548d99f44a895f87ca0bfe4132bd8801d13313aebe95bf"
    sha256 cellar: :any_skip_relocation, monterey:       "bb8b413bcad55ae06ea4fd6583e0a448486c1da1685264f5416fb6307f2bdbd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e30eafe08d3fb2806e5e32f25e480a2b1ebb11a255cc2e95431c51b2c70bb05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7370d88ed82cd53a460477ab0689aa5ec3b541049d2bc5636a698330336b6e8"
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
