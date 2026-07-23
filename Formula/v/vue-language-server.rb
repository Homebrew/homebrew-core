class VueLanguageServer < Formula
  desc "Vue.js language server"
  homepage "https://deepwiki.com/vuejs/language-tools"
  url "https://registry.npmjs.org/@vue/language-server/-/language-server-3.3.8.tgz"
  sha256 "fe5bfc654d3e57506f58561ade5d036a2f52e8924c581ef24657c7d4f6474f93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1e5dd447b0c77e33b415ad1a33e1200526833f80dd161390ca7c0936c464658"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1e5dd447b0c77e33b415ad1a33e1200526833f80dd161390ca7c0936c464658"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1e5dd447b0c77e33b415ad1a33e1200526833f80dd161390ca7c0936c464658"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e90d77f116d1b50e960af2ac22b76898f485f7ed7efe574daf81cea38657a35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00083c99514b7c5fad95a69488c72b443f011f10cdf98110de22ffa72242776b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1235f91814c56c6a60938d2a532d4ec4711015d902925583ef32d76e28fe3a58"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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

    Open3.popen3(bin/"vue-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
