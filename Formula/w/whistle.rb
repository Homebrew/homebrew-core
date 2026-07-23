class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://wproxy.org/"
  url "https://registry.npmjs.org/whistle/-/whistle-2.10.6.tgz"
  sha256 "e12e38a503f8f82cdd95db13c6bd7e5c6a75b5a95ec78274b6f33cc763aa0b10"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cf92b6567f25096c686304016d4065102503dfacb79269bc9b7b9da1a8f60f39"
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
