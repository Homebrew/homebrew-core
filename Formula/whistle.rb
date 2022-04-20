require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.9.tgz"
  sha256 "c01c61728642539b3f32d775755bd08d1165f2a83816bc43f47803dcf585784a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9353637051c2fceec5843a6ef22cf2269db1ef3ce306b20736c3afb122d0bb9f"
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
