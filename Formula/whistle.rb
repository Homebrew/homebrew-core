require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.0.tgz"
  sha256 "b24083bc3783c11c21d605cad8351cc428549c279f54ba8de918022266b04d57"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3eea1b58e7a485c03148fd5f0604870ac4bbad677b91f8a216ab1141159c0b7" => :catalina
    sha256 "36ca334232520ffb861ce13ef38fc2e54952dc86b8029f808cd77b33e8fb7b5e" => :mojave
    sha256 "41586ba0bf4d3e44268400461ee2761734ce33ed81558fdb694a480636943015" => :high_sierra
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
