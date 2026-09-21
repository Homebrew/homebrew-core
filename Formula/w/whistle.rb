class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://wproxy.org/"
  url "https://registry.npmjs.org/whistle/-/whistle-2.10.10.tgz"
  sha256 "f04b0744547cffc03aa18efb56949db3bdbfc787466b7773246fd7d5aa347def"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f2a7e20beca60973352f8d0272fa6f9185b9408416e8d0e2a02344bed2377d2f"
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
