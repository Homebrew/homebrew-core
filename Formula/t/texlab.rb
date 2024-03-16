class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/refs/tags/v5.13.1.tar.gz"
  sha256 "4ce3e078fe9008056a48c392d2ba8e89cfc5f289be041a714d5140a150e11224"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46209b42530ff1d70b9225dcc4ff0fce4d248ebf0a7afc18d48e0d7690afdd4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c23fcfbd3a76fb11660d5c753ca941417019d97606fc8390aef5f331f2e2571"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c207e750e3c13d89bb09927e9603af79aa0a99297759ee077cddf02f8abd781"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b8ea6916a4511d23e07c34dcca739a139bc80ea22680768de1a8dd6ea1d812f"
    sha256 cellar: :any_skip_relocation, ventura:        "539d5dcd86cb14ade71135ba75bcedc46cd31baf7156b8216323715a295c4c5c"
    sha256 cellar: :any_skip_relocation, monterey:       "53d3f4be2e653394aa2bd10a02fbfb327a0926168c26b6a5f01b713cb3444e34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5281a8f089e9032860787c8543afb0df58a5b0c49d11a6a75081c0213c7c8bb1"
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
