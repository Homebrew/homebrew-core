class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-03-20",
       revision: "825833c26938d25a95f4c77f0e7011cffc34e15c"
  version "2023-03-20"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "100718a677e90b85cc08278b1a74b602248ef828ef396013c1ad4b0be26af5a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76ba660ad0f1e718b2a328eb9a4cdab8958bbb25385c4d8598f3415d5c75faef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b10fdf3764201e21b4686db5c170274eef52d747e4ccf206e59931f775bf572b"
    sha256 cellar: :any_skip_relocation, ventura:        "ce7727502c8e458d58f82fbae65c5d73da21d5bd701075cbdad0c14284b15471"
    sha256 cellar: :any_skip_relocation, monterey:       "d3b374623820f8a49e6c940064ac0af7afed663a13a8380e2ca3fcefa8ce4d78"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d9d2da1bf26579ccfb966e56f028f0a7a98adf98429bf92cdaae423bbde74f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1824d249767c1c7dde34460c5f59bbafab784f6af4169595ee1fc0472ea08253"
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
