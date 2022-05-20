require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.17.tgz"
  sha256 "e53aa025df1c74490824116fa038bb8868f0b2b01c01a5586a2a30ed366e4b30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f4e4d311ea72d41a87062d8b07f6db32efcabcc9d13cd9e101d1099e0e65587b"
  end

  # `bin/proxy/mac/Whistle` was only built for `x86_64`
  # upstream issue tracker, https://github.com/avwo/whistle/issues/734
  depends_on arch: :x86_64
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
