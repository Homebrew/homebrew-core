class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2024-03-11",
       revision: "574e23ec508064613783cba3d1833a95fd9a5080"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "128915bd18643ee208dd32de7a2fbfe4bbb6688dfa6a576513544e72b25f6913"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3e31e833ed5ab119dd9749b55ec91229b834199ea444e86ee7e9689b6b7a620"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "243191fed2872c16c6ed31b0f12ad5e10c71c06a576914da75f1f3d41825b152"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f7115f451030b77c7393078f2ddf6d4de90c39afea6e0d87204d47ba2176b99"
    sha256 cellar: :any_skip_relocation, ventura:        "b7f52d3785ea31907527b9beee86170e80fffe870f2610bf3483f4744b411e4c"
    sha256 cellar: :any_skip_relocation, monterey:       "0807df81d57b11e386bb977422737f551007aa2d4814aca78723c86664c4ca61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0af9f9c769d210edd56927a2e43e0c70cb9605fb09d81e765f36e90de34615ad"
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
