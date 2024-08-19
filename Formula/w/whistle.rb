class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.82.tgz"
  sha256 "9483c1b430e2dbb22754b1089f61e5aca50165744ef824037dd0bcf0e0d1a219"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ae1396bff8ecff8a1f60748521fe62dd8ec377e384612fae884fec2a64a022a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
