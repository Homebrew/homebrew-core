require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.6.0.tgz"
  sha256 "52aa3e5da229d84e20e25ccb1715dde151687b2b31da4bd28deb39ae30002129"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d80d9c648bfc417b590c5e572fe765cc2bc7a0054eb300a73c271afe88ddc928" => :big_sur
    sha256 "772e47590577e57b17437332392c7bb2ac939b5756a47993ba65e3135e447ab1" => :catalina
    sha256 "054e3c98997577be27f1439315704bdfba8b823b4d7d3aff2e4bea0e4d1e1505" => :mojave
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
