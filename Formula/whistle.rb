require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.22.tgz"
  sha256 "cdc582e47f13674355296f30c4191ccbcecf74c51f8b440168ed1971e0fa34e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c0d54d25669c59f0b92620c6cead51310b76a17e9b19214c3b7e530bd6c5a79b"
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
