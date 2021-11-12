class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-11-08",
       revision: "2c0f433fd2e838ae181f87019b6f1fefe33c6f54"
  version "2021-11-08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a197610118d6906974f15c82795d14fc3440f90ab4979760d384e09d23ad4054"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dfd90660608afac24b12b3770ef75f8316a52db64de919733902d9983bb612f"
    sha256 cellar: :any_skip_relocation, monterey:       "561860f91e88844e9cd92ab6f4991777d5eaf9b2649fe1865935972a1a8a2993"
    sha256 cellar: :any_skip_relocation, big_sur:        "912c2ace4ca70e2e252f91134c92efb9a7f6647078f02b6adf5b51ac1cbb0352"
    sha256 cellar: :any_skip_relocation, catalina:       "006315eb5481e3cb8ae767a9b371fbc070428dc63fd68ffd77ea4d6181d22416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "994f037125405f1aa612b6512b6be49ffacaf3f1aceb0a80c33695b465d3ac31"
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
