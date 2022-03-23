require "language/node"

class YamlLanguageServer < Formula
  desc "Language Server for Yaml Files"
  homepage "https://github.com/redhat-developer/yaml-language-server"
  url "https://registry.npmjs.org/yaml-language-server/-/yaml-language-server-1.6.0.tgz"
  sha256 "e9115f7de1c509ee056f4397f1394aa4b7c6781a1bc212d53d9756af1547b0b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a9b19e9a8d710e157af2a728c238d292251b058583c7b38bf687b8d9ca9e75a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a9b19e9a8d710e157af2a728c238d292251b058583c7b38bf687b8d9ca9e75a"
    sha256 cellar: :any_skip_relocation, monterey:       "43936d2be141ed4dda280164fe69abbe38a3a0ed5b93981c3ccd75cde21f583e"
    sha256 cellar: :any_skip_relocation, big_sur:        "43936d2be141ed4dda280164fe69abbe38a3a0ed5b93981c3ccd75cde21f583e"
    sha256 cellar: :any_skip_relocation, catalina:       "43936d2be141ed4dda280164fe69abbe38a3a0ed5b93981c3ccd75cde21f583e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a9b19e9a8d710e157af2a728c238d292251b058583c7b38bf687b8d9ca9e75a"
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
