class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v5.4.0.tar.gz"
  sha256 "3c9596c95f70c0170655791877fbe2869639ecf71f3c6a033a760452cec6c9f7"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8246337a1f10c0011ae48deeb438d2e17825e1b36a7ec2ba1242ee6a2fb6a507"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd015839c27d0443aec6b3d25e8f0bc81cb3bfe4c05d1d5e381aefebd107c31b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1a6a11e88e094a3640baa76f50739677b3ae7b72a127f888b3c6cec588a8d35"
    sha256 cellar: :any_skip_relocation, ventura:        "2a9830fb66530c53e7127cd7f27fed3adc6108c17b6dd1f1acac7fd12bc00e25"
    sha256 cellar: :any_skip_relocation, monterey:       "374aa4b2a4c3437f69a80c1d85bb135974a93137fed19831604e841c0f82a232"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d261ec9bf91f70332896a0f7917acea64f4ba80da746ffbdac7f48e3106d0e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "beb353ce909ad268b1b835b948547e5155b19a8de5461f97921063e0293fc331"
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
