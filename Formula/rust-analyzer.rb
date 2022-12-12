class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-12-12",
       revision: "21e61bee8b74e93f14205f4a6c316db08f811e38"
  version "2022-12-12"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "596140e8cc37a2f2b28082e4582ac914d63ef8a44da0981ae1288c3b9e637ad2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e33c0df0655a387e47bec3670be6c7c944cad060fa089d70959b4f0f1675ed3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "159a0b09f6a76aedccaaec2cf48b627885c22015912743e8885f8079852d3b57"
    sha256 cellar: :any_skip_relocation, ventura:        "f41fba3ca6e5fde5509020faa07438568f6bb7ba17249b3a0ce0e4a42e47a094"
    sha256 cellar: :any_skip_relocation, monterey:       "c675e1f9b570cea58a4bfd2ceb46d75596335efc6c82d9bf503eaa90fe4efecf"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3b60cb691fdc20f47be813f3568dc670bd08e826c26ec7eec58d50e725aabaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e27e913f775265288bc9f435c7de6f4bfad575b127d0885ee5f260db529adb20"
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
