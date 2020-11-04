require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.28.tgz"
  sha256 "9f7557b9124892c86dd76ef61f8ceb849559d2aeab7169660b28462b8254aff2"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c6007cc10270c3fdd4c393f0f7f940deeadfb96ff5fe891436f37a893681aa85" => :catalina
    sha256 "cf3759eed51c643bd746f937013371239e3a29b6916e0f9d4f29a8c7bf6642cc" => :mojave
    sha256 "f0a298feaf7c1ea2cc8f9299ed261fbbd508757e626e72099160571c99c455ee" => :high_sierra
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
