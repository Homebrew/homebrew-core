class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer/archive/2020-07-27.tar.gz"
  version "2020-07-27"
  sha256 "74c98bb90a357bcc131656ec3926b7d03685a1f3be232fb16444d03093ebf2f9"

  bottle do
    cellar :any_skip_relocation
    sha256 "54febeedd75165b291373d6744d747fd5c29291464b2f9aaba35bb72b80cd203" => :catalina
    sha256 "9191423e8fe769e964a622d3fef2c953bf22bb7ecef48e27044739cd2b66d7d8" => :mojave
    sha256 "d5e3e7825d31793aa28351a0254f48a61362c0d895dddb0021b4e979c0c1bd0d" => :high_sierra
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
