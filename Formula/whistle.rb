require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.13.tgz"
  sha256 "1851e6eff384a21a27b9bef3d864bc5ca7dde9d95170e43915f6af1ce477ebb4"
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
