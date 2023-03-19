require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.43.tgz"
  sha256 "8d8bfcd7155006d2ab3ea8034ecd10cf6bc053f827c31b164cac84b8767dfd33"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6415f9b24c8df2c7f24897b0e000a545a76d8ce5617e9ce01d9b882a16d41658"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6415f9b24c8df2c7f24897b0e000a545a76d8ce5617e9ce01d9b882a16d41658"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6415f9b24c8df2c7f24897b0e000a545a76d8ce5617e9ce01d9b882a16d41658"
    sha256 cellar: :any_skip_relocation, ventura:        "e7278fab383972b105578d6e9921eb72cb032764bb513e7e15b18099c198cb3d"
    sha256 cellar: :any_skip_relocation, monterey:       "e7278fab383972b105578d6e9921eb72cb032764bb513e7e15b18099c198cb3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7278fab383972b105578d6e9921eb72cb032764bb513e7e15b18099c198cb3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7278fab383972b105578d6e9921eb72cb032764bb513e7e15b18099c198cb3d"
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
