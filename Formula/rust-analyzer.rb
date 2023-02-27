class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-02-27",
       revision: "4e29820f6d9880606a403e7bec6e91312e7f0575"
  version "2023-02-27"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99c0a13630bef5f37d544c1538b15ff372fd4b0da98088ca911d053698650b01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "011de49c114638bdc4b067e06ae343efbcfb79f695c2afdc7b5692e484c8e290"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db305df4234df478d86ca669ad5d3f8161633fb96e49fc0fad58e2d95026693f"
    sha256 cellar: :any_skip_relocation, ventura:        "666feef8da7e9b28e3ab58709f62eec477202287547c65ea836464884fb85f4f"
    sha256 cellar: :any_skip_relocation, monterey:       "7283b97096c9639a27ec3103b7489fafe9f660f5df4480106e7be3e16ee87d1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "4633f6969e6db6dd474a740442ab77477f974a66655743431bf0c3ea312a30e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d571ddbc9ddb6a84c8e1f15dd7cdd505c12eec14fe0628f316d0d0dda9ad51bd"
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
