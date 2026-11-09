class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://wproxy.org/"
  url "https://registry.npmjs.org/whistle/-/whistle-2.10.14.tgz"
  sha256 "a9c898d442473ae84889cf994a50868bc17e48229b8741d0f0a4e61e6b54eaee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a3efce0bc54c54e988b9f7a20ac97eba3df3193539458d19dacec0acbe4f4a42"
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
