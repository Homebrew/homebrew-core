require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.6.3.tgz"
  sha256 "31f11603a1bdbf5f31ff863096d8bde965f186fecc17895847a9032c3250c68d"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7cc8f1727222fa0db92227e7f9818b7aa777c9441c11e6447114a699fb0024d7" => :big_sur
    sha256 "ee2aef9758edbb838161d859c5c9a28afe416aa657d1c64799c5dfa6d4bdb265" => :arm64_big_sur
    sha256 "6f1de95e9ebcc2b55202c9c4fd5d3bf4f563efb139e79ffbe14b607aef443067" => :catalina
    sha256 "46b3b3e53728b4c13ce0dea5f17e9b31b19f62e7f716ee27ae8a43b79c25b0fb" => :mojave
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
