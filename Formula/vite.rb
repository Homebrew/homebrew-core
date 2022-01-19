require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.7.13.tgz"
  sha256 "225aed818f1e8b39e21cce15afad66b869c489182def46ebcb94e0456851c5ae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "063b23feb4a72252b1ffa0b4b01ab68c6db0a424c41360e4c557045a0e2839c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "063b23feb4a72252b1ffa0b4b01ab68c6db0a424c41360e4c557045a0e2839c9"
    sha256 cellar: :any_skip_relocation, monterey:       "054f04686bd59421955fc9a187aca1956da76cde2622383e3d4280b06703cdbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "054f04686bd59421955fc9a187aca1956da76cde2622383e3d4280b06703cdbe"
    sha256 cellar: :any_skip_relocation, catalina:       "054f04686bd59421955fc9a187aca1956da76cde2622383e3d4280b06703cdbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c8702f8ac69f3c87fbf844b6725094e247b05c4b5b13f94d0413d40328c8d3c"
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
