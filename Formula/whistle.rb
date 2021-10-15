require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.29.tgz"
  sha256 "20b85a58ea4f2c389ed8aa0c538b4541579d33d96b2dc5afb22ce57586fd910d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "175bf1b204ee6411153d1abbdcc244ed3a69255f600ee9dd838e7014c8830d10"
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
