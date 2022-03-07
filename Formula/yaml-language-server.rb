require "language/node"

class YamlLanguageServer < Formula
  desc "Language Server for Yaml Files"
  homepage "https://github.com/redhat-developer/yaml-language-server"
  url "https://registry.npmjs.org/yaml-language-server/-/yaml-language-server-1.5.0.tgz"
  sha256 "0dfa33f4aa994536756ce59cbc9e2e7407fdafc2404247e1610d3fe44bb936ed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1951d267c881e8aa7c3dffa66459c6eecc7b24c42c44210a562626568346c99a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1951d267c881e8aa7c3dffa66459c6eecc7b24c42c44210a562626568346c99a"
    sha256 cellar: :any_skip_relocation, monterey:       "2ffe139ffbbb29457d2ca4fc337c08c8d94bb0e6bf0712aceb248ede135ebcfd"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ffe139ffbbb29457d2ca4fc337c08c8d94bb0e6bf0712aceb248ede135ebcfd"
    sha256 cellar: :any_skip_relocation, catalina:       "2ffe139ffbbb29457d2ca4fc337c08c8d94bb0e6bf0712aceb248ede135ebcfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1951d267c881e8aa7c3dffa66459c6eecc7b24c42c44210a562626568346c99a"
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
