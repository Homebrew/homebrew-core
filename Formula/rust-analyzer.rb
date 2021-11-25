class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-11-22",
       revision: "183ef048f61ae36aa389d1d0345cde940fe788e9"
  version "2021-11-22"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74092f6f57c99239c587714ff7f8703507a5c5d117b2dd67b70166f3f03731ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "479a6b57524d90414420068ac9ff57828a0bbfcbb1433ad4f56f9f9bd9fa81fa"
    sha256 cellar: :any_skip_relocation, monterey:       "9e364ffaf1e20864a21d2a777b909e1ab551e18b81daa0814110692307a58406"
    sha256 cellar: :any_skip_relocation, big_sur:        "81063bdb5243a2bf8af0a70568e96c2691081a0f59459fa9b8d814be317cb556"
    sha256 cellar: :any_skip_relocation, catalina:       "48a157f41d644ec1f416fe6ff9564e0133317b8caf082b5d32ff64ebf4600d1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b99f86742b5a167eae3cc9b1b1086d442163fc4d8778396e201397260d7490e"
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
