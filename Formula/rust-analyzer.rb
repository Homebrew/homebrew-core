class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-09-20",
       revision: "f1d7f98ed07b9934286b9c4809dd4d7a47537879"
  version "2021-09-20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fafbbe843b0882ebfc0c38d8c4368f6ad8c264447fc7a4c96f8c628b52926f41"
    sha256 cellar: :any_skip_relocation, big_sur:       "8bc898716667e3b83423098891993554d2ea2454f1073790fe96875dda9eb602"
    sha256 cellar: :any_skip_relocation, catalina:      "39001f66e1bc2f7d018e6342da9f2a04b42987bdb0d551c69ef95416e1b658b6"
    sha256 cellar: :any_skip_relocation, mojave:        "bf327033ee05c8e139ed8b34040e20dd81ab7bc5de84a0a895dea5b2f5d453c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc2df94a23561de9e0110953e6afaa4d14c9d33970505530d09f9b1617d0df45"
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
