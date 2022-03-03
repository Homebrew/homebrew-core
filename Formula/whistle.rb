require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.3.tgz"
  sha256 "de8bc8dd29dbc89b9271739f375d485498289f6c1be2bd73c5055071948eef1c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "68162709316daaffcc08eb9779f91f8e0b863b311777d5e6a181b8b2465a5733"
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
