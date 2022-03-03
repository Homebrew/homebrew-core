require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.3.tgz"
  sha256 "de8bc8dd29dbc89b9271739f375d485498289f6c1be2bd73c5055071948eef1c"
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
