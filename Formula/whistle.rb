require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.41.tgz"
  sha256 "f6cb9cc4a5b87719830b049cda54bee5a0b3cd04cd9a52f941e55c65618a0e61"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a96cfdb3c6f2d77e281d54340ee1cde9edbb90a1a441437debe33bebdf95bb68"
  end

  # npm dependency `set-global-proxy` ships an x86_64-only binary.
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
