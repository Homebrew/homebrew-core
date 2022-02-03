require "language/node"

class YamlLanguageServer < Formula
  desc "Language Server for Yaml Files"
  homepage "https://github.com/redhat-developer/yaml-language-server"
  url "https://registry.npmjs.org/yaml-language-server/-/yaml-language-server-1.4.0.tgz"
  sha256 "44f7de28a1d2ee35e82ac6694a55fc8002aac1fe90ee645b86e3bae82b074ac9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76bc2f0f7e22eebe4af0100370afe5f521513fb1f40943675bcf96e567212737"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76bc2f0f7e22eebe4af0100370afe5f521513fb1f40943675bcf96e567212737"
    sha256 cellar: :any_skip_relocation, monterey:       "edfc7608ff4d55596c1b65fef083bd5b2c65e45a61ec3361a0d7a4f178927a97"
    sha256 cellar: :any_skip_relocation, big_sur:        "edfc7608ff4d55596c1b65fef083bd5b2c65e45a61ec3361a0d7a4f178927a97"
    sha256 cellar: :any_skip_relocation, catalina:       "edfc7608ff4d55596c1b65fef083bd5b2c65e45a61ec3361a0d7a4f178927a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76bc2f0f7e22eebe4af0100370afe5f521513fb1f40943675bcf96e567212737"
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
