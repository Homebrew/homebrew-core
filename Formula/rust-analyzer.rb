class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-10-17",
       revision: "0531aab522f25d6aae30b2cc23a09f4b9257eedc"
  version "2022-10-17"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b206e880f1a13f3548baadcc2aa40f9584b9bd5281b87af99ec7ccc189189d34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc5d3ec2187482024ffa0763be4111b2ac6dc8eac38c804588c2f286db919140"
    sha256 cellar: :any_skip_relocation, monterey:       "6f52dad1b577cdb9e472bc7a91591a335e9759f21e45bf2ea32999736ec670c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "6074fa281f4c51d2fd032fe428efb060c4aed9302ed625536544669a3d555329"
    sha256 cellar: :any_skip_relocation, catalina:       "484d7f4c484ab947fa4b11cb180251c1732cd4ddd8cc2f4ed1ecde0b427cc8c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1313337d9eaee1da0fb00a522cc82f966219d7e0bafbd5f92a2141beaabbc17b"
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
