class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-03-06",
       revision: "0a956ec9326eca09725d64d9f1b63896f93505d1"
  version "2023-03-06"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff9193490615207ec9de98baedfbd410072fb1610ce2c509b1617eabfbc1f955"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40aa43a4811ed9de63f210df14dd99b97e724efff5d571e0f5e70f133ff4ecc5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ebbe705e76faa6db9d9e4da30b9e031479c3f91769de313c6b1bcbd7a9f9c9e"
    sha256 cellar: :any_skip_relocation, ventura:        "4e388ac4055310eafce5fd9add3d705b454a07e321b9494cd9f52d865ccf08fa"
    sha256 cellar: :any_skip_relocation, monterey:       "cb10f89f88a6e24f7a72616f1d0ce1e0c532a4190865cb1891b3955030bd1123"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5a8ce029258c9cdd57e6fca7aaf3f06372728a1c2f441e8452b539da3ad4e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40edfbd22093f0645370960e91ec693a631532c90826387a98e1a0ce8e992fd9"
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
