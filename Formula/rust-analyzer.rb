class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-02-15",
       revision: "7435b9e98c9280043605748c11a1f450669e04d6"
  version "2021-02-15"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d408f0f2b97fe434423b7cc4821fafc386a6952116a63b3dc0ba1b4907c51b3b"
    sha256 cellar: :any_skip_relocation, big_sur:       "123ec7da168d51f4f6238e0529ba914ba6d09bb184674025d6eda3c9219eb27d"
    sha256 cellar: :any_skip_relocation, catalina:      "c4b4827cd35ef4e4c4d5c9dd344b4f474a4d713c9e0fd778b00507966dceccb9"
    sha256 cellar: :any_skip_relocation, mojave:        "dd3811a060f87e1b0680f3031bff18875873b5719101733e044584920ac79841"
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
