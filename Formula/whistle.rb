require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.15.tgz"
  sha256 "0850a540e197bdd9066296e2b410030a068be6cbaa500a24ff234bb0eb5dbd2a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9f2545592f5bf0815273681b136cb3e8adbea827f13c5684550c3a09f75bc373"
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
