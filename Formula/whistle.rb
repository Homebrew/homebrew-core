require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.1.tgz"
  sha256 "2b91225941ca2d7f37f0943004ac2a7a99aec938b5d395f78b87f8616a514ee4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3d6f04dd2be8935b0c22e343f9033c7fa86bfa56bb747ba222d2029e483b2e85"
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
