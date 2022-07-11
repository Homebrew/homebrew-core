class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-07-11",
       revision: "5342f47f4276641ddb5f0a5e08fb307742d6cdc4"
  version "2022-07-11"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "419b2697ce3a4ded5d4f0373b6476d88b2e6833759772b3157841213a8130576"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "920b12c95860fa1b69262f47729956e88ace61c05d80a3798883a9630bfc9df8"
    sha256 cellar: :any_skip_relocation, monterey:       "43dbf79889851c4c125c16af10f026a481abd7e19980d26b59d131e98adf0b1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "39021b3da4c28b5005773b274fd8c6886057d59c08cc9d009e225403f11dcf11"
    sha256 cellar: :any_skip_relocation, catalina:       "3779a592311ea21f49222fb58dfae7da18cbbb48dd97e2d56f2f7b442a1c3994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67322c2edc88eccb5b79ceff3a4f54d373f82352989bfb2c938001d172d2b30a"
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
