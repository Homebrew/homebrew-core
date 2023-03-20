require "language/node"

class VscodeLangserversExtracted < Formula
  desc "Language servers for HTML, CSS, JavaScript, and JSON extracted from vscode"
  homepage "https://github.com/hrsh7th/vscode-langservers-extracted"
  url "https://registry.npmjs.org/vscode-langservers-extracted/-/vscode-langservers-extracted-4.6.0.tgz"
  sha256 "d94b4dc5c4095ccfbb140119aa2dafdb4c7fdf4204c69ef08e56633b068346e6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "969ee0fb2fde9d26e639337f7c48db4ffa4890fb7840eecdf90e21a84584634e"
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

    %w[css eslint html json markdown].each do |lang|
      Open3.popen3("#{bin}/vscode-#{lang}-language-server", "--stdio") do |stdin, stdout|
        stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
        sleep 3
        assert_match(/^Content-Length: \d+/i, stdout.readline)
      end
    end
  end
end
