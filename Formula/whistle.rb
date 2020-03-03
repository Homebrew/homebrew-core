require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.4.12.tgz"
  sha256 "d3d6aeae13447104d44662c42237a935fc16192044d4efebc9b219db26f11e32"

  bottle do
    cellar :any_skip_relocation
    sha256 "151336f17e7dbbd467abbcd32b0d38849d34b92138097c6592f1451ea4c0f933" => :catalina
    sha256 "05a9c55e3b1c1c80714dd561c290ee6df8d2f763681f4a465a035511833dca2d" => :mojave
    sha256 "21500dbf014a150d2ac77ac8a9f64395102274409b9e8ba85cba3b8891d9a2fb" => :high_sierra
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
