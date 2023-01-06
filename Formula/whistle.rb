require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.40.tgz"
  sha256 "c80c140f48183bbe42f9e81ab771f787bcd2ff6a2599535bfae76dd306e5e43e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "de465ab1a5a8cdaf471e5126f3e59cc65daa769d21d879220a6f568da8a3616a"
  end

  # `bin/proxy/mac/Whistle` was only built for `x86_64`
  # upstream issue tracker, https://github.com/avwo/whistle/issues/734
  depends_on arch: :x86_64
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
