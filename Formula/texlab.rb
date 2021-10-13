class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v3.3.0.tar.gz"
  sha256 "0b205c8ee72939e8179c924a426fc33abca08adf93a3175aebe67b34b600505f"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c15558cc5c4297a13770fa2a6b3c2237142f3a7a027d36e9047e6f6735975e1b"
    sha256 cellar: :any_skip_relocation, big_sur:       "8cb35b2970670ab7037d651f2fac78205986a206e3c650363643acb068e892b1"
    sha256 cellar: :any_skip_relocation, catalina:      "aa55d9a0b9dd1b66bbcd1c69b9d8eafd49a36d5330a2d5018d360b058f422ab5"
    sha256 cellar: :any_skip_relocation, mojave:        "ad2c1d6d1d524118cb8930311982de91681c71129fb5bb2bf26b2fa389761cfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fbe8e19f1f26a70e28cbbd613cf7747939d822a8dffbc5b40f5dff39531c78d"
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
