require "language/node"

class YamlLanguageServer < Formula
  desc "Language Server for Yaml Files"
  homepage "https://github.com/redhat-developer/yaml-language-server"
  url "https://registry.npmjs.org/yaml-language-server/-/yaml-language-server-1.8.0.tgz"
  sha256 "5d97dd6af0d88ce85ebe72a235e8268d5b47854bcadaccdc82d594c7b6680ebd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8695f5ea822f5c34ddbe4572a7db48d5113aa276f86bf7846ea8166ce37f365d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8695f5ea822f5c34ddbe4572a7db48d5113aa276f86bf7846ea8166ce37f365d"
    sha256 cellar: :any_skip_relocation, monterey:       "10549479b7c1fc9d629e3e615d2cda90efc2edf6299556d9315764bf81c22e44"
    sha256 cellar: :any_skip_relocation, big_sur:        "10549479b7c1fc9d629e3e615d2cda90efc2edf6299556d9315764bf81c22e44"
    sha256 cellar: :any_skip_relocation, catalina:       "10549479b7c1fc9d629e3e615d2cda90efc2edf6299556d9315764bf81c22e44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8695f5ea822f5c34ddbe4572a7db48d5113aa276f86bf7846ea8166ce37f365d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
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

    Open3.popen3("#{bin}/yaml-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
