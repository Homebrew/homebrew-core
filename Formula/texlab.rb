class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v4.3.2.tar.gz"
  sha256 "166738741ad9873076d123ae86d7642060232f23d2674d59a2d38e1d03a6e06a"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a2f7eaabe3f79283eb0a7482d655197e171b4be2d6e1dd018fccdf3214dbdd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "430e0e7eb92e75c3c6f627a706c85c8fa8a9d2698ba88058c53c2dbd91e7b155"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81d1866a498b543e22e6c97e42a80ea5ae077363de5f089a8be574c2b52dbb58"
    sha256 cellar: :any_skip_relocation, ventura:        "3c4fe860e1dacd9ba4c2fe3d2deea8e7e36d6b05344002f252869e9a768361cf"
    sha256 cellar: :any_skip_relocation, monterey:       "b56e5c82281dd7c409a7e0687915d36d68b09ad51cab5cf168f92403584ba582"
    sha256 cellar: :any_skip_relocation, big_sur:        "c45d498c1b1e47821ce51ef413c5b1865f525acf31b27469d3368fa9de512904"
    sha256 cellar: :any_skip_relocation, catalina:       "02468dc06b7b4d1a22fe731abd661a8f1883ae343b6094c88ccde7624392a870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73853ff55aa04a799d3651eeaaccbca3ee99ada4c480583983375abb6d0a9d61"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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
