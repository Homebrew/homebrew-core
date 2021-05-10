require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.6.16.tgz"
  sha256 "ede87651b0be0222b979b858f70c624cd789591d617db89597d1d3b70f4dc527"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0018483d2fbe66a54eec36af25d3117ac0341243f0df15fa16c12e4f2a63fca0"
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
