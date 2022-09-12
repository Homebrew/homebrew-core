class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-09-12",
       revision: "2e9f1204ca01c3e20898d4a67c8b84899d394a88"
  version "2022-09-12"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d70e30d52bdbc0d552ebdf59148b6c603a4b0c3745c6e756118c4f0dd1c9a531"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c711bc16f10683a93dac5ee42b63148bdd63f5077a07698f059bf23117205cbd"
    sha256 cellar: :any_skip_relocation, monterey:       "9f2cd0b921541ddd13754993d32e88d3ac1d2c1ab6f57f9c5ed8275b9a25a683"
    sha256 cellar: :any_skip_relocation, big_sur:        "55bea94954f005e5282a827bf1146cd98899b6e3f3450f5159067d236ab12ac8"
    sha256 cellar: :any_skip_relocation, catalina:       "691b0e14ebce7edc1a57301cccdf50c8cc067fc845d348a210f242fc180c7f9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "769b3355a6b27562b48760966866e79a673da83be201b49643a5f0a9b93ff887"
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
