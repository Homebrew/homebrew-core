class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-01-25",
       revision: "3ab8d7a9ae1b8c5e421a4666f6693ae7278a7a3c"
  version "2021-01-25"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "82d28b6cc0cae4767b4d00dec04a6109428605d0ebf411e1b965d7e77cd1e64a" => :big_sur
    sha256 "29dadc59d9286a5578efb793a762ba200d2d1d216d386fc3471620978de70555" => :arm64_big_sur
    sha256 "2239bc90895d8b34b9e1039de5dc8c10b3363ca5f64e213fb5b2d938cfb9f67b" => :catalina
    sha256 "b8bb87cc63eedd1af9bc091f417c075370dbc4af8deaf36c32f2af322f3fc047" => :mojave
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
