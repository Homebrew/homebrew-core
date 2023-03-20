require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.43.tgz"
  sha256 "8d8bfcd7155006d2ab3ea8034ecd10cf6bc053f827c31b164cac84b8767dfd33"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebc1065e962d6197d7d38235315330233c53807a4b6820c2caa5d27457b1daa0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebc1065e962d6197d7d38235315330233c53807a4b6820c2caa5d27457b1daa0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebc1065e962d6197d7d38235315330233c53807a4b6820c2caa5d27457b1daa0"
    sha256 cellar: :any_skip_relocation, ventura:        "b69101cdbdbf18b5fb5ad2b85be620f4fa8dc95f038e4320653423fce553a793"
    sha256 cellar: :any_skip_relocation, monterey:       "b69101cdbdbf18b5fb5ad2b85be620f4fa8dc95f038e4320653423fce553a793"
    sha256 cellar: :any_skip_relocation, big_sur:        "b69101cdbdbf18b5fb5ad2b85be620f4fa8dc95f038e4320653423fce553a793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b69101cdbdbf18b5fb5ad2b85be620f4fa8dc95f038e4320653423fce553a793"
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
