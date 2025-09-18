class VueLanguageServer < Formula
  desc "Vue.js language server"
  homepage "https://github.com/vuejs/language-tools"
  url "https://registry.npmjs.org/@vue/language-server/-/language-server-3.0.7.tgz"
  sha256 "741c85404be6ab468f3a24f6921c6900229f9c87737ca630f7f5aac71ff947d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7ea70419d72b3aea7417f0c5fe67c84d801a1d651e6c639908c67858aec7192"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f749da3268eb9f737f23061eeee7c4460a7b5325221dee17addd58e5cbbfa76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b52acffc3963f5908f2175c5066b5019edd18e1efc2cd94f077c6e2470f8884"
    sha256 cellar: :any_skip_relocation, sonoma:        "37e2b7990c4ad644193c7214d3c147cd299dcf7a25f5ed3ee7f7636051f26637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ea38a4e9e766eeddfa9a68accc313fb8302ff1db7962e05a0a47d8af5369b1b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"vue-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
