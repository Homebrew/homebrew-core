require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.23.tgz"
  sha256 "79882e86f9091660cd6c612ce2ddeb61f7b50ca5ed92db140e3d2bd266ce9a9a"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f3eaaa67c00481f922a51fdc4f8e8264a1870f42ad306376a471bedaf48642d4" => :catalina
    sha256 "861c978726b0da4951cb3466161c767bc13c841244e8e6304985edad3dcea16c" => :mojave
    sha256 "419b2a38012fa2988854fd316aebae5f8088048f8551efcf10739dac137f2f62" => :high_sierra
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
