class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-10-16",
       revision: "6572ec8d94c83f8cc6afe0069269abeddc37c25e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7108f213089a3ea053b72542f15050055d76eedbed6479783086ff04effe53e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da02694fcd626840282fe65acb06186aea436efdc918f6957d276a6d1b3a44a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9b9c94e5e3124bab2ac231e0646c04b1caa691d59f8c4c083c5142b5103a60c"
    sha256 cellar: :any_skip_relocation, sonoma:         "74cdea2483ccaa945fea2300bb7cd4616969eb2fff433f63ea258906cef65a99"
    sha256 cellar: :any_skip_relocation, ventura:        "0cc5cf5a2907b04b3adab48d5137fc4616f4ae6e75c074d9be7a67549d027d7d"
    sha256 cellar: :any_skip_relocation, monterey:       "133453b2f70421930d9a1cd8f54342fb78f65bf505e21c43d1ac5e72ddfe8f24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f4df3a7683d23e490f982d66705798c34d4a4fb1640d5f4854113f9265ffd21"
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
