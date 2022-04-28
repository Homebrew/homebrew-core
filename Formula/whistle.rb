require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.12.tgz"
  sha256 "54adbaefb196e90e6ce0dd586d8bbd9a566027850be24db9280335103359503a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "531ac88155b2aa44eea290d29825594efe9a1d1565d2d6f094482fdae57b2617"
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
