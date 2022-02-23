require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.2.tgz"
  sha256 "d9ea4bf8f95094d353b4dc3c52ab2559d216263fe098aed2a870aaf7ae74d213"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a6729797bae161c0f9403ee2b4b9980d12ee4ebd3e4ecb342b434f4686ae2121"
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
