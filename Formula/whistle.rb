require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.6.tgz"
  sha256 "23620dacbebc9d3973ada0c6b4bd0ba72a95e42a94c03887b27cb9ea79bf4140"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8ec8b15258ce92f1b299f0b633786074ae16c0406f0bcb40e590a22105b914bc"
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
