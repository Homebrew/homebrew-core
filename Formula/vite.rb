require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.6.7.tgz"
  sha256 "271bb34a8c9735e931792cb95addff0426e3d5e38c0c8dee454a0994a73ad0eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "71fc4f2ae5f8c51d8ee5dfdfc7154655d90df278d4616e16d9e2aeb3c8d0f867"
    sha256 cellar: :any_skip_relocation, big_sur:       "ea03d3b24d70a2a5764b58fbeb4960269699ccdcae140c25b6d9e0802574c61a"
    sha256 cellar: :any_skip_relocation, catalina:      "ea03d3b24d70a2a5764b58fbeb4960269699ccdcae140c25b6d9e0802574c61a"
    sha256 cellar: :any_skip_relocation, mojave:        "ea03d3b24d70a2a5764b58fbeb4960269699ccdcae140c25b6d9e0802574c61a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dced5f71fa5932b4ee013844d2c8934f735180d731fdb2e4f8910010ef1ac79b"
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
