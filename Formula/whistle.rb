require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.46.tgz"
  sha256 "07bb48144c215f582093dee6b206fb23e0a30ffeb728ae98cc2f6c6a84a12623"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4efd7ea407df854db06015df0d780be000c9754be39097c01040e2d0e4cf72a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4efd7ea407df854db06015df0d780be000c9754be39097c01040e2d0e4cf72a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4efd7ea407df854db06015df0d780be000c9754be39097c01040e2d0e4cf72a"
    sha256 cellar: :any_skip_relocation, ventura:        "448743117ee60176cd57d445f5c91b3c6b031a779dced2fb49847585b435f527"
    sha256 cellar: :any_skip_relocation, monterey:       "448743117ee60176cd57d445f5c91b3c6b031a779dced2fb49847585b435f527"
    sha256 cellar: :any_skip_relocation, big_sur:        "448743117ee60176cd57d445f5c91b3c6b031a779dced2fb49847585b435f527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "448743117ee60176cd57d445f5c91b3c6b031a779dced2fb49847585b435f527"
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
