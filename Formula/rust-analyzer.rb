class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-12-06",
       revision: "7d6fcbc0be2151bfa85ec146545b42d8be2fb28c"
  version "2021-12-06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20d5a4af377cfaf60b170ceb3e3b8c198054b62ff1f13db98ac799c432aae4f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae196ef00744ebbd8210d9dd60f6347cdeef7c3892eb6bc11d091af7c70ae17f"
    sha256 cellar: :any_skip_relocation, monterey:       "a5c3a270067f482a98807f58aed660c94da5630e579a15fd6044cd800ab3881a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a96dd63277c840989b5372385c4cc97659ed222a7c9997944e2c67b8b08cdae9"
    sha256 cellar: :any_skip_relocation, catalina:       "fdd292ce92222097da8899fa44567b17a1e9d57589829a390e13e75608d0ee7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37e41fae11b360826e8d8bff8913767fea1b174c6cc05c6fd822c8ccdd7e5612"
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
