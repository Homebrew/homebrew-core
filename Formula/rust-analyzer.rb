class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-09-19",
       revision: "187bee0bb100111466a3557c20f80defcc0f4db3"
  version "2022-09-19"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "544590ab1dfe4730ba0a37933b61f1a9adf46a6a25c44178b922d84ce6755978"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "506905c01a1cf78d52f8a79ecdf198f3e0ec42a2c6caa01bd24951021d0245da"
    sha256 cellar: :any_skip_relocation, monterey:       "b939258bc22da3c0ffccccbed164f316990083fb0e736ad7888df5f6be3430f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "9175e41f7e82514a6fbf2b4d85dd0a3313b2cf8c5469f6c1f640ddd41195ba48"
    sha256 cellar: :any_skip_relocation, catalina:       "024d766af949438e922ded61eea72f1a5bdc6ee4f82e9b3c49ec21ade684cbba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60640a3e816d7768979ceb9fbc16df63faf2246ef38259aad1d57124ee5ab5a3"
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
