class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2022-03-14",
       revision: "5e8515870674983cce5b945946045bc1e9b80200"
  version "2022-03-14"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddd69e7166d9a10df9e530e61d975b6005dcc198615a30eee2f762b05b3c990b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17ac6f5fd7ae19c797d57947e66b54e8ea80b790403625bb281757bf71f9c0e1"
    sha256 cellar: :any_skip_relocation, monterey:       "06ed94f22947cd297cc6ef1b226b1bd256b2109891080e4fdd0fc78801ac44ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "766e6c43c460e75a036005ea74f29c650d8574d06fb00a44a7025f4c7bfa77b3"
    sha256 cellar: :any_skip_relocation, catalina:       "4b653c53f37e012991f28e2e84c25b12aac4b5e0c622ae10440a4a435d024384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74c3d2802281854aa3749e085122467a25f0ae9b56b20bb259df0420e9601380"
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
