class VueLanguageServer < Formula
  desc "Vue.js language server"
  homepage "https://deepwiki.com/vuejs/language-tools"
  url "https://registry.npmjs.org/@vue/language-server/-/language-server-3.3.11.tgz"
  sha256 "dbd73606bc0691431fceb5aa5d278af0178d39c1154ca6878c526e704cf00594"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b50bae93c087d8cc00862ac325461c139246a992d3d62366a77d6d56b21e888"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b50bae93c087d8cc00862ac325461c139246a992d3d62366a77d6d56b21e888"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b50bae93c087d8cc00862ac325461c139246a992d3d62366a77d6d56b21e888"
    sha256 cellar: :any_skip_relocation, sonoma:        "f82b0b77584cfc37ff40d3dd1a7783fc6c5724331c9181656d6beea0771d9c49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b83f264426a02ba47c2cf73d1423fa27594941fd73ddd4ce5d271c19de5b1aa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0453b3641734dd78c4a23edbf8991c09f4a80069594d4aa7139148d0c197b6a0"
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
