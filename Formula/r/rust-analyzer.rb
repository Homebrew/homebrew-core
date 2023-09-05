class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-09-04",
       revision: "2df30e1e07eafc1de0359566423f471920693a34"
  version "2023-09-04"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b96d16647b582f52a1f979e3bcda38c0a65eaa68447d3751e46aa3b7e397ab5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12cc3c9e10ff89a798587dd86f5a6d1259248fc4286b4cc42beaa819410c9d47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bac8aa31bd5e69f196618d13071072c82aabcb9fce0261547927bffefb79ffc"
    sha256 cellar: :any_skip_relocation, ventura:        "5606d734832aa7264235ed60a765269c710563fa573bdf6af90fa459ee2dd20c"
    sha256 cellar: :any_skip_relocation, monterey:       "d1d22ecbca4a915d2e94c34d36ab1b584c4bc67dbae53c5b18f33b7caec07fbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "55ee9fb23aed2b3dc7f019be2c0d378cbccc921abd27b78f488b47c7f7e13d63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "158b2eac80768e2bc36690993a296a831e516c7c1ce066deb27922f7d3691bf9"
  end

  depends_on "rust" => :build

  def install
    cd "crates/rust-analyzer" do
      system "cargo", "install", "--bin", "rust-analyzer", *std_cargo_args
    end
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n" \
      "\r\n" \
      "#{json}"
  end

  test do
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
