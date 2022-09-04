class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-08-29",
       revision: "e8e598f6415461e7fe957eec1bee6afb55927d59"
  version "2022-08-29"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f15f37697dce52a7a4f68a8992ca82225f9c757dfdf88c9bd983bf9512ab6e53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b88e401044216efffc478ecbda404e97131377880291f36da3e6eafef733c558"
    sha256 cellar: :any_skip_relocation, monterey:       "514f3aad349e6cd8548fe458a7bf4b9756a3811a50ce85ae66134e673a6bfed8"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4de0a6ed451be4abdc13c2b28893ffb563c468b5fd7160826442c84fc047b47"
    sha256 cellar: :any_skip_relocation, catalina:       "9bc67df6dbba344986058c28580a4c4a67d7373cd60f971846aaaf5cef11307e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72394f2372dfb4244d7a3a11306a4db7b7e5826120a4f10ecc2d275e2e334b08"
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
