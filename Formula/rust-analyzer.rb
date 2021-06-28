class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-06-28",
       revision: "1fa82adfdca502a13f4dd952f9a50574870f5b7b"
  version "2021-06-28"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "255a28fe1f80ea9b43135207f89536c500ee9328fe65be9521411a3f3336e081"
    sha256 cellar: :any_skip_relocation, big_sur:       "96d54bf8b312599552587ae9799c3acfa2fd758db91390cba26c0a676399e25c"
    sha256 cellar: :any_skip_relocation, catalina:      "1b0fe670c58c82fae80df89c39e0ac3b8516dab5e4f45dda017a1308f7aba852"
    sha256 cellar: :any_skip_relocation, mojave:        "499a4c146e6a402d155eb0275a40a7a8dc78dd921b6f1308550b78a35ead80ef"
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
