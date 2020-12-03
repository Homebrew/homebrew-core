require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.32.tgz"
  sha256 "f23f8210ec9c0f3797d759a338f9ce058e2a9c051af4ce101d45a9b06afbcc5e"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "310d2b04e1ebb4ff347c0da946356307c6ea0df0283837a8c8af27e1d42898da" => :big_sur
    sha256 "087631cd27aeb6de9c88f49df69178b1e7bd795f6631cfd2b5fae78277d62d17" => :catalina
    sha256 "699906f63178d1bd410c3163a773c1378ddd61bb3dc7bd5abb16d1a03371badd" => :mojave
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
