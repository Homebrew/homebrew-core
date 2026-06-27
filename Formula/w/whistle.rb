class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://wproxy.org/"
  url "https://registry.npmjs.org/whistle/-/whistle-2.10.4.tgz"
  sha256 "11a7534af0c9601f0742e744771b8c8c075df3882386543fc6ca00408dfef66d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b5d5cbe4cabdd3d98df6b60b6c2b0d7efb91a3d4ceaa94f48055661f21ea4c4e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
