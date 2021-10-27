class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-10-25",
       revision: "1f47693e02809c97db61b51247ae4e4d46744c61"
  version "2021-10-25"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65bcfb686dd0e2af169dbc6778f1c4f5d4f62c82164543fefe220deb530d237d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ef15e4248a74539d697d4d87447cff676b271855e02f98c75be082c6c3b2f07"
    sha256 cellar: :any_skip_relocation, monterey:       "fabf72c6fb9c0b4f7aa2d395abcdb1b6003a6b47ce60b00257a35b7ce2a2bb90"
    sha256 cellar: :any_skip_relocation, big_sur:        "70e9a761639d4fef6473a08df782970403c81dd20d42bd69bb607c167effea33"
    sha256 cellar: :any_skip_relocation, catalina:       "a73530465284e232a473f93da3cea2c471a3e7f16b706e1656a6d5c64968da52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c62905cb4dadefa9fa13061b94226bd9084d1d7f9d3f3202609f94a2fcd73c0"
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
