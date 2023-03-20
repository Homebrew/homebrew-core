class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v5.4.0.tar.gz"
  sha256 "3c9596c95f70c0170655791877fbe2869639ecf71f3c6a033a760452cec6c9f7"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02fe85d08707a536df2c3eb245e2cf4a6753781ceb60d3a2ec24deca57c9b61e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2643a9ca1c291ba53f6f64ded5374526a56c3aeea86281eb72dc63a457c3314e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a08c83a7ca6c521d6673bba3770801fbf9e20b488e564df4d92f192781e7846"
    sha256 cellar: :any_skip_relocation, ventura:        "c8ade9e607a6df3c6d4c3b5395d5c9b23f55e9e0ee8711fcd994255a6477a21f"
    sha256 cellar: :any_skip_relocation, monterey:       "cfd61f2098e6953f5b6f3e80cd3c558a79d1b64dcb788b5dd14f6d91e04e3367"
    sha256 cellar: :any_skip_relocation, big_sur:        "91124bf34c137482acbd492863f2fa03cf9c64f7ff005692c098268cb4858522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8032ce002bbc1866720320a7bb6e83b0dec1e113a04c0f297c18c4c5346c648c"
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
