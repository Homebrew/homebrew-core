require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.12.tgz"
  sha256 "5789530f3f808bc32764627baeade82e8fff643c13c750b28f6f0fdf2a1956c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4101c7a469ecd6ea29028ee2ba6df693443d0c5c9d7efb8c53e59e80381f6e0a"
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
