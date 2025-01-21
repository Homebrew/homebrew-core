class YamlLanguageServer < Formula
  desc "Language Server for Yaml Files"
  homepage "https://github.com/redhat-developer/yaml-language-server"
  url "https://registry.npmjs.org/yaml-language-server/-/yaml-language-server-1.15.0.tgz"
  sha256 "b93db2a985437355eb124d44ae60c0569f22cf19473eb0b6f41b8b0d7af579bd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e30f07eca51ae70cfe072524e2b9fcab31530959016c76be39dcfe2c25003a04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "103e85d99f2823ce773ec29c4776b9d75ea2136b7e3b7937c74067ad81043d57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "103e85d99f2823ce773ec29c4776b9d75ea2136b7e3b7937c74067ad81043d57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "103e85d99f2823ce773ec29c4776b9d75ea2136b7e3b7937c74067ad81043d57"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f403dfb87069355b2cc18e4eb9c8883a83bb4f264cc84e6a8a521c9833939d9"
    sha256 cellar: :any_skip_relocation, ventura:        "5f403dfb87069355b2cc18e4eb9c8883a83bb4f264cc84e6a8a521c9833939d9"
    sha256 cellar: :any_skip_relocation, monterey:       "5f403dfb87069355b2cc18e4eb9c8883a83bb4f264cc84e6a8a521c9833939d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4c4e98bd5a4235676df5460cfbd8d32ca2ecd5d3b259553d433093e130636de"
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
