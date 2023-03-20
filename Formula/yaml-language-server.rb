require "language/node"

class YamlLanguageServer < Formula
  desc "Language Server for Yaml Files"
  homepage "https://github.com/redhat-developer/yaml-language-server"
  url "https://registry.npmjs.org/yaml-language-server/-/yaml-language-server-1.12.0.tgz"
  sha256 "38739615283eb32371959ea808869009a315e12faddbdc32b536a463354a2df4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b87e88ec455f481a6f67e95a02f9e2b88638c75955722c9148d4de1b27854e1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b87e88ec455f481a6f67e95a02f9e2b88638c75955722c9148d4de1b27854e1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b87e88ec455f481a6f67e95a02f9e2b88638c75955722c9148d4de1b27854e1c"
    sha256 cellar: :any_skip_relocation, ventura:        "7c9e2035a2629025130aef99e439be0178c72b6647b910a170dd4f52bd1a9081"
    sha256 cellar: :any_skip_relocation, monterey:       "7c9e2035a2629025130aef99e439be0178c72b6647b910a170dd4f52bd1a9081"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c9e2035a2629025130aef99e439be0178c72b6647b910a170dd4f52bd1a9081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b87e88ec455f481a6f67e95a02f9e2b88638c75955722c9148d4de1b27854e1c"
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
