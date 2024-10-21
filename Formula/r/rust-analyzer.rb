class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2024-10-21",
       revision: "9323b5385863739d1c113f02e4cf3f2777c09977"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d3da4f92351e9eefa88f004db28ce1b6e31f1c44488c4b25053d92ef8305b05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0625c06878f181e11b2078e60d5a2e70dc80e2240b1a47fac3d27675deffb17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac7ef837bf8370ca580f48a10395f2b326975d6e1538686c3ad6111665b1d444"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cfe39a6bd6abbcdeaed9dc01c0618564b4e9e5f9edbd9061679be78609cde8d"
    sha256 cellar: :any_skip_relocation, ventura:       "b2b69d2325c2b37df42b517e3528ef25f7e253a0c43d892154d9bde4ef1f3357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "123c470affd1f44e7c8c170da276c8d9b2f78a7bc9ea408e68d690d09ab79fbb"
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

    assert_match output, pipe_output(bin/"rust-analyzer", input, 0)
  end
end
