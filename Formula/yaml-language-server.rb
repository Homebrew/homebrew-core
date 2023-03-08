require "language/node"

class YamlLanguageServer < Formula
  desc "Language Server for Yaml Files"
  homepage "https://github.com/redhat-developer/yaml-language-server"
  url "https://registry.npmjs.org/yaml-language-server/-/yaml-language-server-1.12.0.tgz"
  sha256 "38739615283eb32371959ea808869009a315e12faddbdc32b536a463354a2df4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e68fb5c597e6c45e36d4d32eac4db6aa906efb9522678382e6e2888329086ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e68fb5c597e6c45e36d4d32eac4db6aa906efb9522678382e6e2888329086ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e68fb5c597e6c45e36d4d32eac4db6aa906efb9522678382e6e2888329086ea"
    sha256 cellar: :any_skip_relocation, ventura:        "d7a78fe8232a249cb1f71569bf7f65123329c5ffd75fd2fe391312d12743b681"
    sha256 cellar: :any_skip_relocation, monterey:       "d7a78fe8232a249cb1f71569bf7f65123329c5ffd75fd2fe391312d12743b681"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7a78fe8232a249cb1f71569bf7f65123329c5ffd75fd2fe391312d12743b681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e68fb5c597e6c45e36d4d32eac4db6aa906efb9522678382e6e2888329086ea"
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
