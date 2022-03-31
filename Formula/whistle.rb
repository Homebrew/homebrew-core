require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.6.tgz"
  sha256 "23620dacbebc9d3973ada0c6b4bd0ba72a95e42a94c03887b27cb9ea79bf4140"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8194deb5e16d7f1ede6154fdc24ccf74080a5959a7cb20938fa398d0c67126ca"
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
