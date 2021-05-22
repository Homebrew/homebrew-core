class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v3.0.1.tar.gz"
  sha256 "820d88b078a26eff14e420f985f17704465dfacc70d1097fe0409853420aa6bb"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a7ea2815cad10428a20d326eddcb670151939c865074005f0fdfb6961640c35b"
    sha256 cellar: :any_skip_relocation, big_sur:       "b22583ca6f3fa70f113f0ddea73a298e6c99be713945cf5c946474fa26d86362"
    sha256 cellar: :any_skip_relocation, catalina:      "f349b2eccb43df4c40accc2186f5168bc4af44876fa15533b9afa50687a74bb5"
    sha256 cellar: :any_skip_relocation, mojave:        "0f9901df5e96af58d7710297d3bd272f564a36f184f760e4b2ba8509c31aff12"
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
