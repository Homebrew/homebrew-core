require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.19.tgz"
  sha256 "4e5dc9f1f9087cc36b5f5a6d697ca30c5e3274f2b89e8e8cede490e364cc73d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1e4bde29ed993cfcb3ab9cadc6eb01878b77606d5922b76e1dc8d7e0cd8fa1e2"
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
