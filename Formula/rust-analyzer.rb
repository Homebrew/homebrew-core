class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-08-22",
       revision: "a670ff888437f4b6a3d24cc2996e9f969a87cbae"
  version "2022-08-22"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dadee543b7be90f7caf0cfd7d84afb3cb69af795fd68fb185c917abf83e1612"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f2653518ea78994ed7c5bd07f32e9480da145bd1167841a3d5034ebec7cb7d7"
    sha256 cellar: :any_skip_relocation, monterey:       "b2c3d518ecf6d7bfad1ec0dd1d81f3c843d97387e2e7ee2ff5168f0a19c240b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc0b728df83fc67fd09e75697dc8fae7d224abe3da7f9f34ef6126475c0ab948"
    sha256 cellar: :any_skip_relocation, catalina:       "1759cf9d229acafa802282ff597e79e181c4bb9d6c1826d625a2ba36892ebd45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3db4388e458c38dbe09caee21416b30bcdda80ac8fcb28f98e2fbc8a9b5c94fc"
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
