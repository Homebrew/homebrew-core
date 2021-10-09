require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.26.tgz"
  sha256 "2db94cad759837e9ab2fb3796efbce099ee24c1c787a8a0d15f8e09355e96133"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "97d75e2c72c980fb742cf6355fa3adca32907c1e9bee67478e01eaef85dbb578"
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
