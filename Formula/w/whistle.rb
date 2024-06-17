require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.74.tgz"
  sha256 "1e8bfe4ab3417f8769e90de3988dd877404cf936f3a830d014939b4179e58878"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ee7013e1e5b0e4794ce1b4ce81a41674d510fa4afba9d9a64514c14c6c66bdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ee7013e1e5b0e4794ce1b4ce81a41674d510fa4afba9d9a64514c14c6c66bdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ee7013e1e5b0e4794ce1b4ce81a41674d510fa4afba9d9a64514c14c6c66bdc"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a2fbc53f96d8c72f661e94f2f773d30876f9baf49c1be7f369f3295f19ae79a"
    sha256 cellar: :any_skip_relocation, ventura:        "6a2fbc53f96d8c72f661e94f2f773d30876f9baf49c1be7f369f3295f19ae79a"
    sha256 cellar: :any_skip_relocation, monterey:       "6a2fbc53f96d8c72f661e94f2f773d30876f9baf49c1be7f369f3295f19ae79a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "381ecc44ed977d82766047ef3c9f97fee009c9d6b51fc5cf48fc732f29829177"
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
