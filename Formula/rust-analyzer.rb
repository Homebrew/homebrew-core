class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-01-30",
       revision: "f1b257f4eb4fef74b42fd7135d1cf3884e8b51c9"
  version "2023-01-30"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bcb99cd80bf6591ca94defde4f4aa042f44a9ba939d74cec5664d2881baec89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "828169a8de4521517231bc348de7de50af4ad734c5ce09b065b2ff9309606835"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "791f334d440b97f5c93f60846d0e1fc2e92685b7d350785611a9c386bfa69922"
    sha256 cellar: :any_skip_relocation, ventura:        "13812f4faf5ee8c4e656f20c3736de4005771618834bf2c9c43844e28685fb7c"
    sha256 cellar: :any_skip_relocation, monterey:       "8e7d2be5a63584c788e6b43feab8ff330bc2cbdade60e249a32cd0b0649ab9e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "74275b5e65d9bb604f038cab915b82b76659d0f8e2ff610e0eccf94b398d5c21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c419c758caf74536176ab342231e2cd2f4852e8e22b56b34a446c5a40b47aa30"
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
