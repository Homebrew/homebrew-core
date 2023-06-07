require "language/node"

class VscodeLangserversExtracted < Formula
  desc "Language servers for HTML, CSS, JavaScript, and JSON extracted from vscode"
  homepage "https://github.com/hrsh7th/vscode-langservers-extracted"
  url "https://registry.npmjs.org/vscode-langservers-extracted/-/vscode-langservers-extracted-4.7.0.tgz"
  sha256 "879a28e431f65d3b529d566b47ac8b469581f4c379b28ec3d9da026fe517c722"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5af2c304517f720a9fb73623cdc83b7cbd4807a048a2d7b49e0bf2b5d2ba687c"
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
