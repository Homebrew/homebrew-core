require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.6.14.tgz"
  sha256 "ed2f68d51f815db9ff85c481f1a291abd6eb6227aba3644a0b029e790537347c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a341608164b43913e4ac446c849fc39b989f3459a00af274a412a895610d9482"
    sha256 cellar: :any_skip_relocation, big_sur:       "8c1b1a904700a48ce4cf4418cb86e9454da8c6049448ce21d8bb45c4acb147fe"
    sha256 cellar: :any_skip_relocation, catalina:      "8c1b1a904700a48ce4cf4418cb86e9454da8c6049448ce21d8bb45c4acb147fe"
    sha256 cellar: :any_skip_relocation, mojave:        "48cba0ae1b73117193ae7c1dbc935ca89859682f8bb5e9757a0197b85f12240c"
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
