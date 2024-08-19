class VscodeLangserversExtracted < Formula
  desc "Language servers for HTML, CSS, JavaScript, and JSON extracted from vscode"
  homepage "https://github.com/hrsh7th/vscode-langservers-extracted"
  url "https://registry.npmjs.org/vscode-langservers-extracted/-/vscode-langservers-extracted-4.10.0.tgz"
  sha256 "d6e2d090d09c4b91daa74e9e7462a3d3f244efb96aa5111004cfffa49d6dc9ef"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc7c65e7fc3a6b6e3b8faa96ad591fa53674e1a37af47ed2f720a03b53e5ce95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc7c65e7fc3a6b6e3b8faa96ad591fa53674e1a37af47ed2f720a03b53e5ce95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc7c65e7fc3a6b6e3b8faa96ad591fa53674e1a37af47ed2f720a03b53e5ce95"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc7c65e7fc3a6b6e3b8faa96ad591fa53674e1a37af47ed2f720a03b53e5ce95"
    sha256 cellar: :any_skip_relocation, ventura:        "cc7c65e7fc3a6b6e3b8faa96ad591fa53674e1a37af47ed2f720a03b53e5ce95"
    sha256 cellar: :any_skip_relocation, monterey:       "cc7c65e7fc3a6b6e3b8faa96ad591fa53674e1a37af47ed2f720a03b53e5ce95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c4fb83e422027cda9f1cbcd7f731e108298912148d65d5ecbaf29a8725558d3"
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

    %w[css eslint html json markdown].each do |lang|
      Open3.popen3("#{bin}/vscode-#{lang}-language-server", "--stdio") do |stdin, stdout|
        stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
        sleep 3
        assert_match(/^Content-Length: \d+/i, stdout.readline)
      end
    end
  end
end
