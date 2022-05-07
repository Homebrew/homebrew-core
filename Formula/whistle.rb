require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.14.tgz"
  sha256 "1ca137317fd3197765d0c7ed9819ab73134624a21821d98e47f0825b6ad14816"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "11f4fa842ae5e2711e1b5ea28a6d87fcfbe559baa5dc6eb297db239f66cb64d8"
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
