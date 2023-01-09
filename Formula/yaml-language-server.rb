require "language/node"

class YamlLanguageServer < Formula
  desc "Language Server for Yaml Files"
  homepage "https://github.com/redhat-developer/yaml-language-server"
  url "https://registry.npmjs.org/yaml-language-server/-/yaml-language-server-1.11.0.tgz"
  sha256 "8fe7fc5db9d89d73c5091936b349faee4761e7fcf26612f4322146aea86702c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da9b392ab54ecee90aff6fb9b1bf5dbaaecaba2f961e412fa64ffcb0f99b1cd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcb26e7157119938b58bc8db42169acaea38c173c03ae884de26330bf1e86b88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcb26e7157119938b58bc8db42169acaea38c173c03ae884de26330bf1e86b88"
    sha256 cellar: :any_skip_relocation, ventura:        "297f2c9f362e6e6dc4a4e1fcd98ac1e0a8b22f04c6736b3f4fc3315b4d6b3334"
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
