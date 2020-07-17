require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.13.tgz"
  sha256 "d272445ab7c66af7d7f29fe61e275bc2ab8de4aef072c87b8c800ed488d8ab06"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "681e2314d5dd5435dab1bde95650c91de3fc721769d03ab4eafd9178c2c63064" => :catalina
    sha256 "9814a1374190e68b1fc25b7ca289f490c195715498dbf3ac3a1b5cb906a66ffb" => :mojave
    sha256 "3f3d963a69c1c4b896fa2ef8a21498e70080123313795267ff7945ddafa148da" => :high_sierra
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
