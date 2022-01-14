require "language/node"

class YamlLanguageServer < Formula
  desc "Language Server for Yaml Files"
  homepage "https://github.com/redhat-developer/yaml-language-server"
  url "https://registry.npmjs.org/yaml-language-server/-/yaml-language-server-1.3.0.tgz"
  sha256 "687fdd30a31dbb792dd5d31acfadf1a72058a4afdcb72a79b468ef512a11d19b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9263e1c32411bccec08e034997088e8911139704992e5eb427992f1bfdb3198c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9263e1c32411bccec08e034997088e8911139704992e5eb427992f1bfdb3198c"
    sha256 cellar: :any_skip_relocation, monterey:       "47dccc5d1968883137593117fc16944ae29edb65ffce2ef0782a9de2526a56f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "47dccc5d1968883137593117fc16944ae29edb65ffce2ef0782a9de2526a56f4"
    sha256 cellar: :any_skip_relocation, catalina:       "47dccc5d1968883137593117fc16944ae29edb65ffce2ef0782a9de2526a56f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9263e1c32411bccec08e034997088e8911139704992e5eb427992f1bfdb3198c"
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
