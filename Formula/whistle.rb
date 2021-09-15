require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.21.tgz"
  sha256 "9005230006bcd72129c87487701121302b2fc18c038880c2cc85ad62bd100b33"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "566b48cc9dc9508282bca9006c362658c3a88caef2283d05d8e38f004a3e0b6d"
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
