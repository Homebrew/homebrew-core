class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-09-26",
       revision: "73ab709b38b171d561c119f5c6f94af1bf2e4f3b"
  version "2022-09-26"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "297a14ee61614ead8f32911c0e41dee0416df12c0103ce5968efce447589826c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e30fe43819fa2486cef5b491b027282683853b167d0d97ab3bdf79930159b7a3"
    sha256 cellar: :any_skip_relocation, monterey:       "63cde2a5df31bde7aa53a02b0b12bbfff32de0cdf3d9bc510e5572ac108a9453"
    sha256 cellar: :any_skip_relocation, big_sur:        "aec59ca568f94b7925f9c28ccfbbee0fc8470f243c1fd555b078d6a7bf9e44e5"
    sha256 cellar: :any_skip_relocation, catalina:       "7e194cd61c54e6bf368d42e0d7dc86203a4bc55268d6e3fc594e04f331257566"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfc89c56bbe9ee9f352c8fa78186cb987d24050f99672c8a35152b144e902f3e"
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
