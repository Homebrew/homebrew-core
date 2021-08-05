require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.12.tgz"
  sha256 "5789530f3f808bc32764627baeade82e8fff643c13c750b28f6f0fdf2a1956c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "82da496cc0863a0a9f1a8d62a404cc74d72bea814e0515151798cd1680edb23d"
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
