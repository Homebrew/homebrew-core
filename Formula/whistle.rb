require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.17.tgz"
  sha256 "15588622d8d054f3f8f2c9539e5d2970ff07e0bccada94d1d3de24257ae64d98"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a3cf351d5feba69d8a9c16fdc51c2eea62140977283f02ecfd03820960c9467c"
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
