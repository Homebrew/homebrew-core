class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-01-11",
       revision: "60c501fa19dc446ca8122db17bca9e0dcd5233a2"
  version "2021-01-11"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb1cb054b90094aa271b70f445f2cdb350599c199b4a7ce4b5cd27682736a235" => :big_sur
    sha256 "47be6b305f2869dc4dd4b453b062393659d8f77efd495bbd4732dcbb463699b8" => :arm64_big_sur
    sha256 "05620e54f6a7e85810125ca9c92fd73077659fea9bc92267a7ff5baa149e2ba8" => :catalina
    sha256 "45666e85887015d969525e9811a31e6a7c4dada979e020971b4b0bd154e1b14e" => :mojave
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
