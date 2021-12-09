require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.8.7.tgz"
  sha256 "bf079c514b9d3ead14eac30db50b2f31dc01e7e9ffcf91c9281923825fda2f30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9a36ff0918f5a7c726efe382b8953e97edd4067a5a130b4ac7437cb91cfcedda"
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
