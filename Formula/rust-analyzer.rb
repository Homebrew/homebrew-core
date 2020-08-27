class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2020-08-24",
       revision: "31cb13dde86ed29cc67e23e6e2ca6e89a19e8b62"
  version "2020-08-24"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ea3e0e657a87690a8b3a1ad1b865d2ee444247203f1adc200ff51bdfe744210" => :catalina
    sha256 "a9a10323c9f367a5095c5ae44c0390026ab8fe72f6b0942092de72cc952e65ad" => :mojave
    sha256 "ed16c8322ba1415fedbfba9a77d9fe2cf4a0ef4afa72837e31d6e90aaace790d" => :high_sierra
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
