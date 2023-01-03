class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-01-02",
       revision: "643bc02ded7141a462bc0c9357c8914f9d50fb06"
  version "2023-01-02"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb8541f3fcb3c2c981f75b21fc91aa1178602f3848a39ae68f909ad7a17ccb8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dca6ab88b300c4dbd380f9b785a8afccc212f675715592c1129caaf88020c412"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fbafbd976b871dd5e2ed03555bf2690b4abac09d79dccb07db5da7902dac0df"
    sha256 cellar: :any_skip_relocation, ventura:        "45c71b4152cc82dbebe977f9da4bb43c4426b1bc9d3aef2d44e029a8e2f5b285"
    sha256 cellar: :any_skip_relocation, monterey:       "63d8cdc01b325fa94f8e55ce0fed4da794b9dcaed9779b6d6cc1d1c698073075"
    sha256 cellar: :any_skip_relocation, big_sur:        "ada32fe9a3d086e7d23784969e77e2f8be313d37a8ee48aab2926631b922f4b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e0d885ad1bc2bf3c8034e8ea5f74fe3c0fef2e588c096b8c5e3ab88b395c5cf"
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
