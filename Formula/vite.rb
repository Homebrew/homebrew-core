require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.8.5.tgz"
  sha256 "5acae2d43d4a566c1326008f278fa775270d364ba4b30fc835460928e221a024"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6bb25480c63477b9102b18eefc9165c613b3a9ff568a3191a9e5a549cab836d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6bb25480c63477b9102b18eefc9165c613b3a9ff568a3191a9e5a549cab836d"
    sha256 cellar: :any_skip_relocation, monterey:       "3d25ee8d74fd647985f1ea98590ed565b25eb5a1efe375782a28638dd43689ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d25ee8d74fd647985f1ea98590ed565b25eb5a1efe375782a28638dd43689ed"
    sha256 cellar: :any_skip_relocation, catalina:       "3d25ee8d74fd647985f1ea98590ed565b25eb5a1efe375782a28638dd43689ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf8078811b54d4da93a73c4699cab72b319f4d08baa3fd680ecc82aa15a59efc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    deuniversalize_machos
  end

  test do
    port = free_port
    fork do
      system bin/"vite", "preview", "--port", port
    end
    sleep 2
    assert_match "Cannot GET /", shell_output("curl -s localhost:#{port}")
  end
end
