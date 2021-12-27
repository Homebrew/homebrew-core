require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.8.9.tgz"
  sha256 "8db1d3ff18ee01b90bd10028cbf2db4d1c4f0c3fdbe3ed2d38a48d1342ee2e45"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6865428556a8b6af82b3a11b98baea2d304d4847e7ce0b355337bfbc5a321a34"
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
