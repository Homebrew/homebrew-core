class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v3.0.0.tar.gz"
  sha256 "6ca624104cf9b354badcc3e6304daafca2e022e92dd0d70ac010b6a9b943a5c3"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "30a8a884b0ee5b2d4199557ee9f2a03f747925fed2cc4846f7d82afe87633ccb"
    sha256 cellar: :any_skip_relocation, big_sur:       "e09837b34a494d6bbf2be7e6e7e97c11ef3b4058f37ed711526ed982bf2c6aa6"
    sha256 cellar: :any_skip_relocation, catalina:      "550652fb9f61859242d41abf46089fe3b4ffffd82880864e2106ae493d66e4f3"
    sha256 cellar: :any_skip_relocation, mojave:        "66cfcb0de8c45b10e15e906195f68736f47ec3165dd6eef48c6fa48c560c966e"
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
