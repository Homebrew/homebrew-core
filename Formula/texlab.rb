class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v4.2.2.tar.gz"
  sha256 "db5426766c7d9f23fb269fa27c725af459728a3d3a1b0642dc823fb7b26a8f93"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8a48f32c982820afcb7375e3651a2baa3f1ba4e1be4401872a3a7069fe5ea8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c51dd6ef9d6ff5f02e57fceaca37bc803ba38518811b0ba39bad27fdfb71c441"
    sha256 cellar: :any_skip_relocation, monterey:       "2ca7f183125905105e48ddc98b8ed079b358149899eab525e1b855e1d53a8ed8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b69f5aa51bfbccb4b0d2577d797238eb7ab18259696d307897d9fbdd1b56df1f"
    sha256 cellar: :any_skip_relocation, catalina:       "1c8c672ebc489f8a1b70538c4e6266da84b6257f28580f0c57bc9182203f1918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3002e3e29296db92fb5b06a99281a30e02ba43d94d80de6b66e6921e153addbe"
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
