class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2022-01-10",
       revision: "0f8c96c92689af8378dbe9f466c6bf15a3a27458"
  version "2022-01-10"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fe0507d3902db1e52dbe3961ce6afe1bb956079c6c6e0126cbcd73e2b33c854"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "035c745a235edc8e671a18cd2a4070bc283f97bb97a2a7c22047de2c1aa879c1"
    sha256 cellar: :any_skip_relocation, monterey:       "d421b3dfef0f90e5b62002da2053a4852715587241ee824424493b95ed7e08d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "c879006f8efaa92d000416978408c27d9c0554c96927341ceb6d4db38ff43cd9"
    sha256 cellar: :any_skip_relocation, catalina:       "7043f497e728369333c10395a4d10c82062631466b6621e8cc1d59c6473fee04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e7203f02dc407471dc529e666e1d257b2a6c7dcfca9dd420f1bab62089a42c4"
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
