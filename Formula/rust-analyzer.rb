class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-08-29",
       revision: "e8e598f6415461e7fe957eec1bee6afb55927d59"
  version "2022-08-29"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9f4f682d1061a8d0f3b02288f9eac1e1efc7d6c7e18dd8948087ead4a5e0583"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7521196c9849e1f004dcfc0d4d47d91bde07dbe983a802c52e73fd97913f7d85"
    sha256 cellar: :any_skip_relocation, monterey:       "ff2e48a2646968812f0c59a4a051b7c4e96f04bf9cf255f47d5b52e843299f29"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c2fb26969113f2ca61734c97914b5dcbb4b01462b2dd0849efb84a494954d54"
    sha256 cellar: :any_skip_relocation, catalina:       "34ab8fdc8518498704f450f4514a3970804e078c4583819a2d769141a304e7ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "079e5e15391ddd736c94bf3fd1d21095811800dec55b33e31eba74ac61bffd2c"
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
