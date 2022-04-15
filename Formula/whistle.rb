require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.8.tgz"
  sha256 "40e33be160f923735540b9db1d8735628f45549d9b2e969d966f6de58fef2d0e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3212f0fcd327a63b6693cc8ce607a9311a7931f8641b93e1c2f25021b91235ba"
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
