class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v4.1.0.tar.gz"
  sha256 "f7b5300c6fc93d7c339c755c67ea84f9c5daced2fb2735545d01a67ccf2ff770"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04320f6d1985d27064e7608942be21744ec057eace805099abca67071f4c7fd1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d62fa4354e7333387e6b1772f5a3d9a2064310a8ec1701ee01bc59a14ed2f4ee"
    sha256 cellar: :any_skip_relocation, monterey:       "f7433890664185e3d9330d9784b7d8ae3cb7ea0efc959fe1e59bf0dd09df03e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "da6fb8de103851d1bbda4ea290bcd7bafc03c23fdf3a56666847af80e66bd69e"
    sha256 cellar: :any_skip_relocation, catalina:       "ce88085446349d27c9d6ca31de09f86caa3eedbaa51c4408f861b5ebd33a83c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f839df3586c0f26e257df122ca98397b5330f64c592db41a801f7818eb4bf370"
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
