require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.21.tgz"
  sha256 "9005230006bcd72129c87487701121302b2fc18c038880c2cc85ad62bd100b33"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fde5b99c1f82700c213cd821997ed372cd52e6e60f0455e23cf6986b80b6819d"
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
