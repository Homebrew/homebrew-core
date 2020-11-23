class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2020-11-23",
       revision: "cadf0e9fb630d04367ef2611383865963d84ab54"
  version "2020-11-23"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d09a16a8368fb4ebf0e9a1756297a117c0ba8508c5ad0d4c88c08b399e177d5" => :big_sur
    sha256 "aa9b1a3ddaaa83c4ef6781d15befe7dd9723bbfd3540f76a5bbd7bd1982cd6ad" => :catalina
    sha256 "378f33ac4b25a0ee89f471b30016d9f30a1807ff7f8e9f1d42f74e1900364deb" => :mojave
    sha256 "3e8884fd6210fd3e66b72ebf08a0b58b2a1b14335aaf6a8b53b5c313d6632a9c" => :high_sierra
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
