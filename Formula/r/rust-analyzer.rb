class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2024-06-10",
       revision: "b427d460ebafcd9ba01607a2c920ca7572559288"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f3471e5caf41aa243c34b8fdc3d6bcfb739d26902d5f86f3078ce7ca0dafcfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f68f7a9b2d67514306378cba728bbb39ae068ccff508c12a0c089095b299a00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b93ac6086750a125fa6b2a18bfdb278eb8483d09bc6baa9d95b4685d8f97939"
    sha256 cellar: :any_skip_relocation, sonoma:         "f84febd7a4ca03c56bed18850e95fd0a7bd43189434f3eda9ca7ba49848f701f"
    sha256 cellar: :any_skip_relocation, ventura:        "2ab12d3a7782049d42aef773ee107215cad750f6a8b7fc581b3b5b2c5255eaa5"
    sha256 cellar: :any_skip_relocation, monterey:       "e3dc6eccfcbb4d80a4b9221e0894e8a38082514258edcbc77123e3a8ab477b2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49678826bbc887e3a1bd7da96d6fc0724bad36b29b689031d15ea7c452451017"
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
