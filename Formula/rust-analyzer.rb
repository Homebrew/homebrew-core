class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-04-26",
       revision: "617535393bb5ccc7adf0bac8a3b9a9c306454e79"
  version "2021-04-26"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "543800ec235bbd6a9d23e544e45fe1b3e0c8d93e5a502d88f0e124a7db23de29"
    sha256 cellar: :any_skip_relocation, big_sur:       "3accf352a35e289e7f88dc838ecba7c388e022320e9ecb7916bb03ca9383b029"
    sha256 cellar: :any_skip_relocation, catalina:      "5169b0196a4744e2429f393cdbda37d16c1def982130f9260f41769ef617c406"
    sha256 cellar: :any_skip_relocation, mojave:        "17552b52365ce678093f9b138ae57d47fcb2636cdf271762ef71a8c9f9eccf2e"
  end

  depends_on "rust" => :build

  def install
    cd "crates/rust-analyzer" do
      system "cargo", "install", "--bin", "rust-analyzer", *std_cargo_args
    end
  end

  test do
    def rpc(json)
      "Content-Length: #{json.size}\r\n" \
      "\r\n" \
      "#{json}"
    end

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
