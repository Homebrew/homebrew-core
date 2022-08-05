class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v4.2.1.tar.gz"
  sha256 "5333487e31c6b21fc9a4b351de844fc11626452b98d6413d9f5bc620aa5a0966"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "807e5a1d314c71cf7915b0c2c272e335aaf0f360f2ab4fc44ce71fdb50bd9539"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d4262fb8c0b35c2a53e1aae0a7ccbfd0eec76e97e96b6ba89f052a0a9c4bed9"
    sha256 cellar: :any_skip_relocation, monterey:       "0ea0b3dd56231e6dded79ffc3b356fd07b6c83b4a5fe2ae204d89a510b3bd4a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "be941b57c5f638b6bc7f096b599cfdd23f38c8f319ecdf6625afb513f89e22bc"
    sha256 cellar: :any_skip_relocation, catalina:       "c01949d88f7b0a2081360cf289220fa09e71b2de6df63f16b29ab1f1dd9cdf3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93f14b33648c6ee256eb3fdf0ffadef83ec9d341073061bc72e8791dc8f9c304"
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
