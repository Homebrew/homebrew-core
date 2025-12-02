class YamlLanguageServer < Formula
  desc "Language Server for Yaml Files"
  homepage "https://github.com/redhat-developer/yaml-language-server"
  url "https://registry.npmjs.org/yaml-language-server/-/yaml-language-server-1.19.2.tgz"
  sha256 "1b2c10f1acb09a87551d54ad666b8f7e16023ceb5c7270489a67c206025614f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a7f711394c0d4737c7a81dac1da400867b4f55be7854f6309f41ebf68ac2d51c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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

    Open3.popen3(bin/"yaml-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
