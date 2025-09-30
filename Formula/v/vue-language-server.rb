class VueLanguageServer < Formula
  desc "Vue.js language server"
  homepage "https://github.com/vuejs/language-tools"
  url "https://registry.npmjs.org/@vue/language-server/-/language-server-3.1.0.tgz"
  sha256 "f21696e3aeb27e5c4b8f44fe8d021e3b322a1cb4e131f8a2e22716eb6d917e43"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11f8e5c233d9e39f9cc1611eb6b06f3a03dd1344eeceb31fa03da590a1c8c198"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4389f0b6a7054972547a48b9334313f2b0c0e0b820062bb19ca02b457058d53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49a6f34743c064967e156eae8cd109f8ac9355e712ca030f7c7fb1792971d296"
    sha256 cellar: :any_skip_relocation, sonoma:        "a27bcacc70976b7e62fba8d0481189c81af7919cbaf77a8e1c6814b12312ca9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b2d02be8bec5cf8765ed0dd361ae7481e65afe9ffb623ce4eb4605881a83f07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17c3acfaaf8f79715a1fe2f596eda34a283aa08337fe4b3241633c05d454ecc7"
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
