require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.4.12.tgz"
  sha256 "d3d6aeae13447104d44662c42237a935fc16192044d4efebc9b219db26f11e32"

  bottle do
    cellar :any_skip_relocation
    sha256 "431cb27f8501f6ddcf064d537607b0252c979ce1232d55d901d1152ad5ca1eb6" => :catalina
    sha256 "d0057af6e5da91e69993c5a7e299c89f5a317abfa521599bec0804a6b1c71f21" => :mojave
    sha256 "f7ddfc104438c0e65b3696d766d4489727cca38ad6b2032898d676ff3f1af9a5" => :high_sierra
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
