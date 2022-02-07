class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2022-02-07",
       revision: "ba330548023607717295f0dfd61b72eda41aa9dd"
  version "2022-02-07"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caae5a0613ef6315f2fb2da49e8afd244703ec9acfac03058a5ee71dc4b4eee5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6aa449edb3ef1de2156e0bd666d70b8070a0b28ce237b0fdd892901096f4fcfc"
    sha256 cellar: :any_skip_relocation, monterey:       "923526005236c0c2da5cad556713aa2bc5b9e394e97b04995065413a9ec47b8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6313df3c99278f0b2639a69e36567fd72bbfb6c4997bae2daeecf7fff577b3c9"
    sha256 cellar: :any_skip_relocation, catalina:       "62f902aab9320b02d6271932ce04958900abfa13b6560cbe9ff0f7138079274d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "471d9bec9a0457b638d47b7a55cccf575c412ec218e140ba74346750e9e574ba"
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
