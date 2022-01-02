require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.8.10.tgz"
  sha256 "ac838815f1e9214e25a74bdc3f40bea4606923f4857f04ced502a228959839b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "db0fd5f3a7e474c39967bd14e82182328d838d7aa832b9e5aae458de8bf17ec1"
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
