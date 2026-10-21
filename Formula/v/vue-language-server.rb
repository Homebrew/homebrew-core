class VueLanguageServer < Formula
  desc "Vue.js language server"
  homepage "https://deepwiki.com/vuejs/language-tools"
  url "https://registry.npmjs.org/@vue/language-server/-/language-server-3.3.13.tgz"
  sha256 "39013d18a4e639db5988ebabfb2ff49393940c6cc492731dc54c5b8fde6b24de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0d601455a0c5e2c3c36afd487ef8e59324a7e10a841dcd77374cea3d6aa53f9e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0d601455a0c5e2c3c36afd487ef8e59324a7e10a841dcd77374cea3d6aa53f9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d601455a0c5e2c3c36afd487ef8e59324a7e10a841dcd77374cea3d6aa53f9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5a9394f78fe2a9536413963aa76efae87d2ba0da265c34cb5b4d40dfa788661b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5d1b370052bb1abb4e2bc8047b14f940ded3ffa6437badb66d330718fa37f695"
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
