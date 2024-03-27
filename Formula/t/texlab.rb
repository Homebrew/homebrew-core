class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/refs/tags/v5.14.1.tar.gz"
  sha256 "506fd5e4fd5c82358035bd3c6a99fcb0ac19fd1033e0dd97c0078ec23a13dd55"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47947bfcdfa0d692f95749406e013a3e189ef9660687c413d4c6b05ddf9acfc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ccbc82751fd0692c13af3f7e60564534ac61b3468f369d6587732f988c34478"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "483ee7d1b3660ab2e9dc693e429e72c2623f310a4850b6a5ed0c9c5c1e4fdd9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f1226a1327e1a6f1d1da093f95e1173f870517ba7ca9ce02beb45de63c99bd0"
    sha256 cellar: :any_skip_relocation, ventura:        "2661fb30c7201773f7367ed342d7c31a9ccce4e91b61780a5f7836552e06a7cf"
    sha256 cellar: :any_skip_relocation, monterey:       "4bc37fd91dc63a54937b46ea3938b0c8351de942fd9ae014340c96cac009a2b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "731929781762f262b97b77a45796902f4b78218132145547c3b122657240dbc2"
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
