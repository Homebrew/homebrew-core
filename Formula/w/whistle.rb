require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.70.tgz"
  sha256 "9a0b47d66c88a8f01941cb33bcc527d96c4f9fb38840eacce98b7aa57773b551"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "86e1e628a907b9e2d7241ef1cabb242d1b297df9b6c165feced9dfd5c46a84e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86e1e628a907b9e2d7241ef1cabb242d1b297df9b6c165feced9dfd5c46a84e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86e1e628a907b9e2d7241ef1cabb242d1b297df9b6c165feced9dfd5c46a84e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c3cfc8694de846310f8720555ddcdfe7b01f5225d836e417c0aed3643352053"
    sha256 cellar: :any_skip_relocation, ventura:        "8c3cfc8694de846310f8720555ddcdfe7b01f5225d836e417c0aed3643352053"
    sha256 cellar: :any_skip_relocation, monterey:       "8c3cfc8694de846310f8720555ddcdfe7b01f5225d836e417c0aed3643352053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c3cfc8694de846310f8720555ddcdfe7b01f5225d836e417c0aed3643352053"
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
