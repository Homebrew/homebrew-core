class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-01-18",
       revision: "fde4a860aea903a0455a05c1def1d07a6573639b"
  version "2021-01-18"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7081d272661b1eeb74448a861680f0aee80ad1da8783c3bc2bdacbf7078325f0" => :big_sur
    sha256 "ccd533fcf051311aef6bbc93ea58a17495fa45692d50c589610abc349a2c378b" => :arm64_big_sur
    sha256 "a0a3d365e3347325dda3300f3ac594c4822bf80a5902cdebb655a7abc5b6a799" => :catalina
    sha256 "b2486fcb1b9510769dbca31bae045a4b4d435e28d6eef50d7ff5fd0c4b51177e" => :mojave
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
