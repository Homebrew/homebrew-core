class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-11-29",
       revision: "d9b2291f546abc77d24499339a72a89127464b95"
  version "2021-11-29"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff6c41f62ea72b5bdfea30b88efc5a049f885ff88b8f612986c7a7a774224007"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d27edec590509dba8278ae3d14f6e51d550e6571933397a85c06e262b6eb07a9"
    sha256 cellar: :any_skip_relocation, monterey:       "87dc25ca0bef484711dac8730638ac243ea2c6dd0955951a70f28e382fc9ff13"
    sha256 cellar: :any_skip_relocation, big_sur:        "e553be7ce130e89e57c6bf814a55f8b124f8049b56b592866f2ac90d954925ca"
    sha256 cellar: :any_skip_relocation, catalina:       "c688b4988a148f0db370847aab4cdc30d39fc06537404834cb39a7c332afdded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d708a06331eb851774585ca5fb435f538e98fc7b05509db4674fbe61768496a"
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
