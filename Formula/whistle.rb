require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.13.tgz"
  sha256 "fa82d0eee96e779f1b1b48bd308617925fa19c065860edeb94ae011e8fd6b7b9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d36e55ea8ae3a6556d4e115b175aae1dae31eeb678956f14888aba580ce29677"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
