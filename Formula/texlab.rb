class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v3.3.1.tar.gz"
  sha256 "a39766f497dfb2cf9e370ddc430b7d275cb055b4d8a0751d718a86072747a75c"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd11cf24bca68961984697b24b111a8b5e47a4e559d8190fd5cd677ad00faae8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4dccfaaedccefdeb181c4a2dff3e5cf8cc1347795c71b02ee78fae466da0540"
    sha256 cellar: :any_skip_relocation, monterey:       "a30ce78a3342b5437ecdbe55d4b9d131720d720109a86eca1f18e059f6072ca4"
    sha256 cellar: :any_skip_relocation, big_sur:        "6dc5319b6c717275af9e7a21454e0ea5cd9637fc9120822ae58f16a57fe4a028"
    sha256 cellar: :any_skip_relocation, catalina:       "4555ace0b8df960855919f8c017bcd2e1c542e433cfa46871567e92e9670a05f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d21d3570548017d53847ff7f8ae2e02e9f6b124f8276e9515ad6c2050ea7e48"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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

    assert_match output, pipe_output("#{bin}/texlab", input, 0)
  end
end
