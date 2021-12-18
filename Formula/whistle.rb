require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.8.8.tgz"
  sha256 "85604cb9245300c4549a39d85dae7e741944c12801e54f4e2258ad18627b6c7b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9a36ff0918f5a7c726efe382b8953e97edd4067a5a130b4ac7437cb91cfcedda"
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
