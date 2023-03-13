class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-03-13",
       revision: "f1e51afa450ecf352c1f01fc5a5b6d10792e3779"
  version "2023-03-13"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a61f261a2cc610f7abff0e37e0f3b722df14220fd3e99d8c0157cedccfad0d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a907e363ae16a5f4d8897d4c0bd13825f790bcbf3d6a17ca775854a98ff3383c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b26bd534efdd9a1cb2a21a36d974efc7275120c88591cb76aa8e724e47dceb4"
    sha256 cellar: :any_skip_relocation, ventura:        "feca9394a6562f2d6a594fcc111c94ff0bc2686ad3cd9e14d3c2e87e8917ef8b"
    sha256 cellar: :any_skip_relocation, monterey:       "d5fa9d4d16451c69eec69d988dcde3608d99041a2736f2cacd262a4fd23a5c7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2fd65a142bae5e78cfa3ed9d38d1ee1e599efa0ac45518833aa0fac3c2297cc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6acdaa51c8062f3d00566bdbbfbc6bd89ca73405dbc460e177669ee6b7e208ed"
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
