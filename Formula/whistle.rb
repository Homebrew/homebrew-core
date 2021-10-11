require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.28.tgz"
  sha256 "11b81acb542c2810867947c0925b5045c01396a2620eaa576db09d620f783ec0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0f9ad1cfa876b626f2d9eda40581acfb49101f4c2335e2fb1393cbb34f2d7296"
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
