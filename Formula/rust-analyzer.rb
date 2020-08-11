class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer/archive/2020-08-10.tar.gz"
  version "2020-08-10"
  sha256 "5aa91ced95650ccf7430db4ed314c9fe37553049ada05b28fa9ec20999328a79"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0f82c1c55ae7f4cd27d3d79c5e402fa62a6e12b49308e9aff31ea1d796463c6" => :catalina
    sha256 "407fe4a2b44e4ea5e63b1d8e238ffb62a1ca3039b478a99aba47c0764152ec35" => :mojave
    sha256 "aa1617d6db720dbb01cf4666e836e92aa2d82c7a02600c3de76729d6ecccc901" => :high_sierra
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
