require "language/node"

class YamlLanguageServer < Formula
  desc "Language Server for Yaml Files"
  homepage "https://github.com/redhat-developer/yaml-language-server"
  url "https://registry.npmjs.org/yaml-language-server/-/yaml-language-server-1.5.1.tgz"
  sha256 "83ad356247aa7b6e09317e1414a912d15e3610ac1d2925b281fb6e0e3ac43aee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caea0f3368465db15066d8750f79644f8a693c0d8527c89e9ddfe00707f78d77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "caea0f3368465db15066d8750f79644f8a693c0d8527c89e9ddfe00707f78d77"
    sha256 cellar: :any_skip_relocation, monterey:       "6a501b9382987557d2d314be79f2c411b77dc47ae5cdfb18793744d66c572c67"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a501b9382987557d2d314be79f2c411b77dc47ae5cdfb18793744d66c572c67"
    sha256 cellar: :any_skip_relocation, catalina:       "6a501b9382987557d2d314be79f2c411b77dc47ae5cdfb18793744d66c572c67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caea0f3368465db15066d8750f79644f8a693c0d8527c89e9ddfe00707f78d77"
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
