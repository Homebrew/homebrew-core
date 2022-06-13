class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v4.1.0.tar.gz"
  sha256 "f7b5300c6fc93d7c339c755c67ea84f9c5daced2fb2735545d01a67ccf2ff770"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36e4f90c7b4896f0faacc18c6b423089796adc0c1e86f91c79d55302276333c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c6e64335dd23f0fdf0bf9a42eff295e845236e438f8a3e7afb416c8373fd45b"
    sha256 cellar: :any_skip_relocation, monterey:       "a4e7ea84a854e3b068d7092d45cef776798567ab964d0fdcdc047bac7207489b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a489728ac86340df7dc7bc148ff1331648b134f49685ad6455ae8c114bb95d4e"
    sha256 cellar: :any_skip_relocation, catalina:       "d674f21e2e02768da23cf07e18d81194d4fb9d4c17c5ddf736a841805154177a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "531425e0e370f46e1260ba91108ea214b511f8a39f9788f866e3ec665570fb09"
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
