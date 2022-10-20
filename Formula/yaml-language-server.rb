require "language/node"

class YamlLanguageServer < Formula
  desc "Language Server for Yaml Files"
  homepage "https://github.com/redhat-developer/yaml-language-server"
  url "https://registry.npmjs.org/yaml-language-server/-/yaml-language-server-1.10.0.tgz"
  sha256 "c6f79cbd5bda19ad678aa1191ff6b36a077a6ccf3c4c2783112be9036945b137"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcb26e7157119938b58bc8db42169acaea38c173c03ae884de26330bf1e86b88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcb26e7157119938b58bc8db42169acaea38c173c03ae884de26330bf1e86b88"
    sha256 cellar: :any_skip_relocation, monterey:       "78cbd354d779a570c10f31e6e997259758a48a7e3a89de0dad0c805b390a81e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "78cbd354d779a570c10f31e6e997259758a48a7e3a89de0dad0c805b390a81e6"
    sha256 cellar: :any_skip_relocation, catalina:       "78cbd354d779a570c10f31e6e997259758a48a7e3a89de0dad0c805b390a81e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcb26e7157119938b58bc8db42169acaea38c173c03ae884de26330bf1e86b88"
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
