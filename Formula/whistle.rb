require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.20.tgz"
  sha256 "f9b329a56c4d48be1cc67395ec79e24a8f9dd4d1ed95ef59689f5a1cb18e251d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "04a6e19b6674e653b4255630ce7e0573af334f61cb8b8c753d751ce3c5975bdc"
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
