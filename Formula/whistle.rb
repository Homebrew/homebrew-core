require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.52.tgz"
  sha256 "181e11c46876740f20384985fa18a795b55573556b480295cf1ba3263513fc23"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5be25291ec14d576c944ba0eab82144b6e9203a4cc55e51444ae570ed589000"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5be25291ec14d576c944ba0eab82144b6e9203a4cc55e51444ae570ed589000"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5be25291ec14d576c944ba0eab82144b6e9203a4cc55e51444ae570ed589000"
    sha256 cellar: :any_skip_relocation, ventura:        "979119b1790a27a6d0a6587f2474f2fe625481f7aac2cd18434dd474a3f31c01"
    sha256 cellar: :any_skip_relocation, monterey:       "979119b1790a27a6d0a6587f2474f2fe625481f7aac2cd18434dd474a3f31c01"
    sha256 cellar: :any_skip_relocation, big_sur:        "979119b1790a27a6d0a6587f2474f2fe625481f7aac2cd18434dd474a3f31c01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "979119b1790a27a6d0a6587f2474f2fe625481f7aac2cd18434dd474a3f31c01"
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
