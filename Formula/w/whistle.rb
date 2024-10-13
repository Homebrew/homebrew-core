class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.86.tgz"
  sha256 "4b7b07675600b085297b11c3d665020135258ed070ebff467c27314bda65c8b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eb763c9d828fc857a6650904e57287609479c3c66934bee4b291bba3f778e86a"
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
