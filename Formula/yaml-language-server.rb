require "language/node"

class YamlLanguageServer < Formula
  desc "Language Server for Yaml Files"
  homepage "https://github.com/redhat-developer/yaml-language-server"
  url "https://registry.npmjs.org/yaml-language-server/-/yaml-language-server-1.8.0.tgz"
  sha256 "5d97dd6af0d88ce85ebe72a235e8268d5b47854bcadaccdc82d594c7b6680ebd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f31b63c765c903c340b23460fe15e4e20636e889f1cd0f27b2a8612b4074e6c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f31b63c765c903c340b23460fe15e4e20636e889f1cd0f27b2a8612b4074e6c1"
    sha256 cellar: :any_skip_relocation, monterey:       "04ac31d843bf61b42cdd97c09e411ddf47157b07ddee2ba4105ebfed1dc1307d"
    sha256 cellar: :any_skip_relocation, big_sur:        "04ac31d843bf61b42cdd97c09e411ddf47157b07ddee2ba4105ebfed1dc1307d"
    sha256 cellar: :any_skip_relocation, catalina:       "04ac31d843bf61b42cdd97c09e411ddf47157b07ddee2ba4105ebfed1dc1307d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f31b63c765c903c340b23460fe15e4e20636e889f1cd0f27b2a8612b4074e6c1"
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
