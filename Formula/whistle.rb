require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.5.tgz"
  sha256 "0a9ee23388129929d208fc474d523e79af69365f0f1e038152ace5f4faaeda95"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fac10240b88bb8c2a87928ab245b1b497f224bee6fb07452a41d2521004a51ee"
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
