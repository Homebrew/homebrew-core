require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.64.tgz"
  sha256 "0b135a3a624af650f21cb46b0a7e2908f3e89a22e89c71bbc556f85ae5d15eba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6fd89e97b7c50777499fce297fb7178c41e53ff4384a890217e61a0dea672eb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fd89e97b7c50777499fce297fb7178c41e53ff4384a890217e61a0dea672eb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fd89e97b7c50777499fce297fb7178c41e53ff4384a890217e61a0dea672eb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "463428c6cda145ea519e674a0bf1a7c1c1788d2ffcd75317610fd4815f019f36"
    sha256 cellar: :any_skip_relocation, ventura:        "463428c6cda145ea519e674a0bf1a7c1c1788d2ffcd75317610fd4815f019f36"
    sha256 cellar: :any_skip_relocation, monterey:       "463428c6cda145ea519e674a0bf1a7c1c1788d2ffcd75317610fd4815f019f36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "463428c6cda145ea519e674a0bf1a7c1c1788d2ffcd75317610fd4815f019f36"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove x86 specific optional feature
    node_modules = libexec/"lib/node_modules/whistle/node_modules"
    rm_f node_modules/"set-global-proxy/lib/mac/whistle" if Hardware::CPU.arm?
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
