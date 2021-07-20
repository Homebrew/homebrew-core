class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-07-19",
       revision: "ea105f9396a9dab68e71efb06016b7c76c83ba7c"
  version "2021-07-19"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "73fb938a0fae61b2194b2907f9695a8d40eda5e560e4d705b9a8412c7b753810"
    sha256 cellar: :any_skip_relocation, big_sur:       "a2cd5a3fd2383365200212fb626cf5ddc57d7291ac2adb85f78407fe5c69c07f"
    sha256 cellar: :any_skip_relocation, catalina:      "167364b1cab5b57be30849cbc26a41051b5920ebbb7bf2c0c1cb00d8e3d85867"
    sha256 cellar: :any_skip_relocation, mojave:        "0e144486a939ef44e8f5935a59a7f3d1804413b4e07879a3e637fbbc9fcaac9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbebcd7360ee3e37557f182330d0494262da94730d450cca3117601798f9f8d4"
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
