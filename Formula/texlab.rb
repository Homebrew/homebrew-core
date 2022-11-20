class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v4.3.2.tar.gz"
  sha256 "166738741ad9873076d123ae86d7642060232f23d2674d59a2d38e1d03a6e06a"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "274614e944cbed724253142c4ba8397bcef074d90bc606f3b66c58b946cc7b7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08fc9377687658b1f19861744de2cd4d2cf0134c0e2125bcecbe9f0e9084d222"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6db4457aea70ae9be2d0f483ea3b3b0334a3eaadaaa62b39f16c1ca4faf0422c"
    sha256 cellar: :any_skip_relocation, ventura:        "e43b6fb72e9af14ce9d42438ec07e3dbb4240a0e158e8da0b72a6e4a0366a282"
    sha256 cellar: :any_skip_relocation, monterey:       "2432b6f38c8bff2bd0c99d35097ff179ad469169388c7422f410fec9274e7340"
    sha256 cellar: :any_skip_relocation, big_sur:        "724f8a59f105f4bef5c8fecf66ea854a99fc261ab24e2ca719638142b5d15117"
    sha256 cellar: :any_skip_relocation, catalina:       "e778b139f56e8737ea03f510bf8ef21d66e15dbb4e09a9fde62c1d18a646fc38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de6e530d2864e104da10f664cd4ee1d90ecf5a7edd2802d6b0ed8a0cbed5541b"
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
