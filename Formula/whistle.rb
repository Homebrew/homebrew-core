require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.25.tgz"
  sha256 "ca09373716571ce19a63a521861eb74f9ece12cc5971a173c5b0d37374888686"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fbc6574d7d2385a318ea0c6442b3bc7d54d7d294d22dbd82aa889ccaab4c7324"
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
