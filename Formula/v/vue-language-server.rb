class VueLanguageServer < Formula
  desc "Vue.js language server"
  homepage "https://github.com/vuejs/language-tools"
  url "https://registry.npmjs.org/@vue/language-server/-/language-server-3.0.8.tgz"
  sha256 "939b8a69fe6a5ca0968ea63347853969bb8f617dfbb86d1cbe1481a2b175722a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53c645ef9f99ece75b0db077d5479a6cdce108221175d65982ebd310087f60b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3084f51dbc310cfe7411396f6b26d0d870033e2b555f61800c29cb12304b67ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cac3aec23792d4b8dbd6658e2efe0f65fc1274746d37de84b57e1f37974ad21d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8c194c613ca00c33972c3a328997e0f3c5c1ac68afdf31b35a40bca54dbca08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "befc9a733a0927e4b71945b2574de6a493f50027053769b4b6e34758047cd208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01604f6f61e8cde77817cb27bf5fe9acc00d333d7ce74a07b45bf05f0b873658"
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
