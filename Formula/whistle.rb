require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.8.0.tgz"
  sha256 "38d4a530181f20a7f46f7105b6782a6bf25ed4db4f7e32ae096db2f0325f26f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3e3c78381e03005883d55308c7ccf044429459657ef86e2651588d013af12090"
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
