require "language/node"

class VscodeLangserversExtracted < Formula
  desc "Language servers for HTML, CSS, JavaScript, and JSON extracted from vscode"
  homepage "https://github.com/hrsh7th/vscode-langservers-extracted"
  url "https://registry.npmjs.org/vscode-langservers-extracted/-/vscode-langservers-extracted-4.10.0.tgz"
  sha256 "d6e2d090d09c4b91daa74e9e7462a3d3f244efb96aa5111004cfffa49d6dc9ef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a7c513b71c7e19d575bffabe3720d26972fd30dd498f3cb39e167d5085d882c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ae76e977c580714608211f6d1ec941e090e29796d6e8bb0f43be1fd4547283f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c94084b34360c77bbd5e723dc98deae0cfc7de7eb87cc7e7f90f649f1cce8032"
    sha256 cellar: :any_skip_relocation, sonoma:         "7bb7bd4273920acc2433277b4b22c55db6fbce9dc3bb7a3d516db7b50f8c6df8"
    sha256 cellar: :any_skip_relocation, ventura:        "8f2efb458646504a94be80cb5e2b280f67c611f5cc0bce246bd70211865e9239"
    sha256 cellar: :any_skip_relocation, monterey:       "d9849d01ed540ae75f1362c54c965804ff4fc3be7d74a0585117b965e99ab6a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a17a73ee7294466810e80001c5a728788413915fa97801e3cb5af47dbd2703e"
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
