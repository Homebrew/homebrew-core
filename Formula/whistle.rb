require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.37.tgz"
  sha256 "02fea8cb98e0a50a5b0aab9de975b41fdeff67b4a2e4f36f2633c338bb1df8a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3def0467b7f764be655b3d00900355d2a4d2c5f6d201faccb19e61b53787a8d4"
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
