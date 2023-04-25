class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v5.5.0.tar.gz"
  sha256 "5b3d9bb13f4a4dcae615a8f656558cd3fa512c8b9bf1bfe413fd1d8ae6d2f649"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86a34c628d9dbfcd30fdb74ae6a71bbe87d71026089d61124e97df5a9bdac22d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2ca34a6dccf854e4d1fc48f1287cff9061c35e2323c24bd2a126c0af214d654"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "666357c873598804c6cb6dbcb66d67cc1373c9e8b4d8936c076cd6674cfa7e0f"
    sha256 cellar: :any_skip_relocation, ventura:        "99025f7d0fe5e62bc256258d1417cd680daaa686aa9a2f3250f1a31c627e4a89"
    sha256 cellar: :any_skip_relocation, monterey:       "3dd75f8c1f652d3292e3264133e3d9d8acc36b29ef36953899f9afe0783953c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c5b62f2ddce834d2f59cc4a3a1150ca9a80dccba98a2184a07131a617bae69b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00828c6763025b01e30324793c9e953880e70a7b3a907bd440fc6c6904685aa2"
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
