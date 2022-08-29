require "language/node"

class YamlLanguageServer < Formula
  desc "Language Server for Yaml Files"
  homepage "https://github.com/redhat-developer/yaml-language-server"
  url "https://registry.npmjs.org/yaml-language-server/-/yaml-language-server-1.10.0.tgz"
  sha256 "c6f79cbd5bda19ad678aa1191ff6b36a077a6ccf3c4c2783112be9036945b137"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cf9c5443359af076f5f67cd18bcb12c6ac730ac94d5d4cb9867d8c5466f10f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cf9c5443359af076f5f67cd18bcb12c6ac730ac94d5d4cb9867d8c5466f10f5"
    sha256 cellar: :any_skip_relocation, monterey:       "5563686f6b55a914de55505acb0ad959f576844f40f0ead5f0a2fd29f1e40e14"
    sha256 cellar: :any_skip_relocation, big_sur:        "5563686f6b55a914de55505acb0ad959f576844f40f0ead5f0a2fd29f1e40e14"
    sha256 cellar: :any_skip_relocation, catalina:       "5563686f6b55a914de55505acb0ad959f576844f40f0ead5f0a2fd29f1e40e14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cf9c5443359af076f5f67cd18bcb12c6ac730ac94d5d4cb9867d8c5466f10f5"
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
