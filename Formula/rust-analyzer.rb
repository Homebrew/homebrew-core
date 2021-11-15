class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-11-15",
       revision: "73668334f05c3446b04116ccc3156240d2d8ab19"
  version "2021-11-15"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8eb9883bee495ff22f0dc1b6b324fd2e1205fefa5f62972f105b0afc30111f0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f169d28895ef07b7557b033ceeafa344d93fb73e51d4097da56f59d49b95270"
    sha256 cellar: :any_skip_relocation, monterey:       "64d97f019dcaa7daaa90ba6c38bfb17ef82de5de3607e6a5b5312d677b724a49"
    sha256 cellar: :any_skip_relocation, big_sur:        "738f14fc88b501199e7d66c5466162d5139dff93336b6ee642714eb8e71f08b2"
    sha256 cellar: :any_skip_relocation, catalina:       "148163020f5372d880fef0032eaa3f95de3b60b6a6b951121df68d9899811b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bddedb0002d8b8836539dacbbe7d5195721b88a37d7b8e0c669f617141728ab"
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
