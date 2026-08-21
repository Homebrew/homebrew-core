class VueLanguageServer < Formula
  desc "Vue.js language server"
  homepage "https://deepwiki.com/vuejs/language-tools"
  url "https://registry.npmjs.org/@vue/language-server/-/language-server-3.3.10.tgz"
  sha256 "41159730da98799ee7b8c6b4ad82e1620b494cac8eb96d6fba83f2fa5bb36544"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b8cefddf886ea1b70b6cc5607ae1bb8a52b96b4c99ec6e0416311eb4eb43156"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b8cefddf886ea1b70b6cc5607ae1bb8a52b96b4c99ec6e0416311eb4eb43156"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b8cefddf886ea1b70b6cc5607ae1bb8a52b96b4c99ec6e0416311eb4eb43156"
    sha256 cellar: :any_skip_relocation, sonoma:        "300e4e7cb591f8fb1cc40d8b23dd02c480ee7aac29d4be94e06308d687bafa2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68b52a0daa1281396d224e52fcdaf5a5d989a09bf4ef7ca84c9368704b1832c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8a8eb8ff0f81418d6069a1e15fe13744a0ab7dcfa8924199229d24f01719ddd"
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
