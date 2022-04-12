class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2022-04-11",
       revision: "24cf957627d5ede1b395f92ff871fd7a281d49a4"
  version "2022-04-11"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9897b8ef3a12617fbe4e603c5c5a2e95ada3f2bb59ef4d9cf169f61c45ab67df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d41d02a5c61fd51150232afec23b7c0a23f85ef682be8d4ca4d07c8af5a563b5"
    sha256 cellar: :any_skip_relocation, monterey:       "88c542a2aed2ae5b6f46d231cc75dbdc8eb39be27fbe82d8deb9b7afa31d2984"
    sha256 cellar: :any_skip_relocation, big_sur:        "07a663bb0bec4a3cd20116dcd9a11464cc5562ce75deddd6709f53ea2015fbf6"
    sha256 cellar: :any_skip_relocation, catalina:       "c69a339933d1798d21e142c2b52b3b4d55c5032f3d84fa2154ce6936fd1a00a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e6821bb4096830c17045e6c27a3a6d8aa6c89af7109be7a683da7452289f3eb"
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
