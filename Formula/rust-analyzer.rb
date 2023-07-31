class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-07-31",
       revision: "429a3816adb99f33ef557767c874d2cd3a1ffa01"
  version "2023-07-31"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eee0341042909542b23c5ef6a19a06fa497f67f88f1369d47cce417238bc9b7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44bc4ccfb2d4b814ca92b628c4b0d52ba0dfee7ee8c1a348f06b78bd19d86b56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6fbf7ddfb2455c23acb733e4550938098c24628f447c8bf288395ba1ec713f8c"
    sha256 cellar: :any_skip_relocation, ventura:        "356146c5ded42f77394755798f362fdd0af72aa9278f07ecc42285c0f80ddf58"
    sha256 cellar: :any_skip_relocation, monterey:       "971e272f075a5786c54334dbbf36eacf4431d825313865ba1b7a349d06587aeb"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d7607b361242794c7d3fd05d643fa69610e20b96953005b9de0476f27e9d3d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae92c78323a77108a7f485a8904d87bc5f1862eb1ae116c5ab745974a6882dc8"
  end

  depends_on "rust" => :build

  conflicts_with "rust", because: "both install `rust-analyzer` binary"

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
