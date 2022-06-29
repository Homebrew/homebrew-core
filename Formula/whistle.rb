require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.23.tgz"
  sha256 "9ae3748c5c20bcacd94d37c03ecc12fd74e4c9e01346448d284e26a304b8b13a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1b8d58714e6b860fe5dac96826c69f30a82a9abcd697bfe240e3d780a234f33c"
  end

  depends_on "node"

  def install
    system "npm", "install", "--production", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
