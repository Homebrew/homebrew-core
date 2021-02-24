class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-02-22",
       revision: "14de9e54a6d9ef070399b34a11634294a8cc3ca5"
  version "2021-02-22"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "12e9a2bec3d1a54a80260417eab629e23a08b79b194727acdd3513ceb800c213"
    sha256 cellar: :any_skip_relocation, big_sur:       "48dfbe37900cd315102b4e6590d9e6363d9d4b7655647ad167cc46297f07cc2c"
    sha256 cellar: :any_skip_relocation, catalina:      "5e1b1248d0170a1ffdee9f973091b4c9ff746435f81a1a3bd748a2b421501890"
    sha256 cellar: :any_skip_relocation, mojave:        "f31e25496aa32be29d652f166fff8e7a845abf58e8e838b520259147ac2a8ec9"
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
