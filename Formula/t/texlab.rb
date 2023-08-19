class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v5.9.2.tar.gz"
  sha256 "b635d592423705802feb442e47622307c2ed12d265f5d48b95b3082f27d571ae"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0509c5062644fbee5ae6664cc2316c5b83cf3de88076458ee806ec568f4f1109"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "293d9c5fa24fe66c6b46c887a3bb82e1f937265d599c77ffe5df6c43c4a7bebc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbce38d24ad3681937387abcfb8bb10892b819c2afca475445766c23a10f58c3"
    sha256 cellar: :any_skip_relocation, ventura:        "eed0bbf7fab83df357011d7693addf24cbc1a0a3590ce4241d5851e7ab72ec20"
    sha256 cellar: :any_skip_relocation, monterey:       "489e505738b5af49fc478adadbd380cbd7eb80ea944a7e3c58e10e04389588dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "85d720b3ef71f868e46bb2c57b24e57ec65a9c0af15127d9640616def34b4cf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba2fa5248b2a9f1ca3cb2d36451b1fd9174be924de038f003f7fdf9cf6c4d7a2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/texlab")
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n\r\n#{json}"
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

    assert_match output, pipe_output("#{bin}/texlab", input, 0)
  end
end
