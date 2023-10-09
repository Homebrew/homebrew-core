require "language/node"

class YamlLanguageServer < Formula
  desc "Language Server for Yaml Files"
  homepage "https://github.com/redhat-developer/yaml-language-server"
  url "https://registry.npmjs.org/yaml-language-server/-/yaml-language-server-1.14.0.tgz"
  sha256 "3a5b8ca99da8fe99602770967825bb6cd456ebd5b4eba013dda4ec8542409a60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44367b5fa0b63eae3267d812672f1abd45ed23eab9e1455071b7f186037fa315"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60c1b37b85cd7d38e8ec5d7bd70f3c8889050d6769e7e9e305e09ee9d6793c03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60c1b37b85cd7d38e8ec5d7bd70f3c8889050d6769e7e9e305e09ee9d6793c03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60c1b37b85cd7d38e8ec5d7bd70f3c8889050d6769e7e9e305e09ee9d6793c03"
    sha256 cellar: :any_skip_relocation, sonoma:         "44367b5fa0b63eae3267d812672f1abd45ed23eab9e1455071b7f186037fa315"
    sha256 cellar: :any_skip_relocation, ventura:        "60c1b37b85cd7d38e8ec5d7bd70f3c8889050d6769e7e9e305e09ee9d6793c03"
    sha256 cellar: :any_skip_relocation, monterey:       "60c1b37b85cd7d38e8ec5d7bd70f3c8889050d6769e7e9e305e09ee9d6793c03"
    sha256 cellar: :any_skip_relocation, big_sur:        "60c1b37b85cd7d38e8ec5d7bd70f3c8889050d6769e7e9e305e09ee9d6793c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58630a2e7caac9a0cf9160c359f0111cd0164c8425bfd623e82de9fce84e7728"
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
