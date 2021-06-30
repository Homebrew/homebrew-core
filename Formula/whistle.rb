require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.7.tgz"
  sha256 "544d13ecc006a77c1aa194f188a6ed5d55b386d796fb61bc81db8b3a1b3dc787"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "66bc90913ae1874f565a1278188061f70c42f55f7840e00d08c7e89f3dfea4ca"
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
