require "language/node"

class YamlLanguageServer < Formula
  desc "Language Server for Yaml Files"
  homepage "https://github.com/redhat-developer/yaml-language-server"
  url "https://registry.npmjs.org/yaml-language-server/-/yaml-language-server-1.5.0.tgz"
  sha256 "0dfa33f4aa994536756ce59cbc9e2e7407fdafc2404247e1610d3fe44bb936ed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cbcc916424d03fc9c63042c103003e0b4b6b89f44b3f316c0e5e8ed2727d8cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cbcc916424d03fc9c63042c103003e0b4b6b89f44b3f316c0e5e8ed2727d8cf"
    sha256 cellar: :any_skip_relocation, monterey:       "77d508305d041e845b0d9e5637a0202c1939cc64f33e02e8c3ee8dfd92068a72"
    sha256 cellar: :any_skip_relocation, big_sur:        "77d508305d041e845b0d9e5637a0202c1939cc64f33e02e8c3ee8dfd92068a72"
    sha256 cellar: :any_skip_relocation, catalina:       "77d508305d041e845b0d9e5637a0202c1939cc64f33e02e8c3ee8dfd92068a72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cbcc916424d03fc9c63042c103003e0b4b6b89f44b3f316c0e5e8ed2727d8cf"
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
