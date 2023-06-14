class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-06-12",
       revision: "d567091f472a6c2b55262e25d092f1d43a7a4fae"
  version "2023-06-12"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f03b1653682b8b919e1cb57d25ef4fec4193022b87266c8a4be9c17b7b898c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bd88ea62496034da049757e06bb8a1decf4a62c98023b70b97db51fc514de08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94a50609e08f7d2d77f12d6af2a2439aea2734914b05bf9f5e1d9e3dbaf57651"
    sha256 cellar: :any_skip_relocation, ventura:        "3e92ea989acba7223a4a1f3d0bddbe34e55dcc285800f24c0d2486b9b4ca38ed"
    sha256 cellar: :any_skip_relocation, monterey:       "0fdfb8bdf0cefe4348f52ce2a216ea18bfa8fd539fe6d91dba32715475ef1e96"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3539d2cd646c5f8f61d3ab1b74c03e02568b69597da6c3c93ccbe5210c9b00c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9c748a83fa8ab05022894e6c4cbe68f91253df17cfa08a4a5a190eda92167a3"
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
