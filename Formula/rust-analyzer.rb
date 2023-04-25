class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-04-24",
       revision: "bc78ebd9d83d614562f0a9280bdedf91a3841a73"
  version "2023-04-24"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06c3a4b2913ea309965ebbfcc2c5cb668dea835b921e5cfc20c27eda0142a8ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "588d3167752e933676d6559069cb3097778b0c4d0f34651a4372c68a751dfdb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbfd8cb55ac02502c4a6e0918dbcdfe043fcc73204e51f5ed6308c4b6fb076b8"
    sha256 cellar: :any_skip_relocation, ventura:        "2ec2434db9916d694d1836a34e8b734fbbda17bc70c92f5aef9709fe9e4915ee"
    sha256 cellar: :any_skip_relocation, monterey:       "3ead16e36ec4a1f2e587ea085d8d9c4af92d7e2e7f6e0d5234f247b2d3e9c545"
    sha256 cellar: :any_skip_relocation, big_sur:        "de9c042ecbece16f95aef16500632ccc5be948fd181ae601dc4c0f8f8b16921d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a716056fd6066dd1651db3ad9423360a8a00baccf4f389cfaeed48d140f1fb3"
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
