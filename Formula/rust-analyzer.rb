class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-07-25",
       revision: "7e2b983fd459977e11026683ee4afb9598960a4c"
  version "2022-07-25"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb9bccf9c2ad349d5e474a307e73099d8821dd36ceb072bae80f6ca0b0c78deb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea3d4758317b4f6837bc5ff916eaade3b3e60121d945e15a27f14c8c353e92e8"
    sha256 cellar: :any_skip_relocation, monterey:       "303f0462bf478c5154550d2faaeb298ff2b3f826f47a5d3458c85b5aeafefca5"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f6fa924901529b46996942485db98fe3cfd14de0f59227980e9cccc4091afa2"
    sha256 cellar: :any_skip_relocation, catalina:       "7013150c3af0105c4e13a1de4a6e8e435486417c8fbee99875b182a281d79da6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36ef63b6b8a4e66b2b04e5054a2e4410324377eabd38c2f4538f532ec97fb13d"
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
