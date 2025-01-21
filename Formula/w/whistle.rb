class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.94.tgz"
  sha256 "eecf60c073a5252cdaf0c60061a8a189ee27ed384cf14075615327619a0f2322"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0d1ca471a03773829b7b0e92b24bf50b0720e50c3ad40c2af59099726f4005d7"
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
