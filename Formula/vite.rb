require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.6.3.tgz"
  sha256 "72b8686de20cf5f44aadfbfa00364266a16e43db81160ad8a4e906abc161134e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1cc397e221c532c4a79d55a49f2d4c313e3d7b4d66c29f9fca7308e094cc1ac0"
    sha256 cellar: :any_skip_relocation, big_sur:       "ef48dd989ffab08b123a6aada1933d37ba0685f70285f4fe3f12b9fd6afe1922"
    sha256 cellar: :any_skip_relocation, catalina:      "ef48dd989ffab08b123a6aada1933d37ba0685f70285f4fe3f12b9fd6afe1922"
    sha256 cellar: :any_skip_relocation, mojave:        "ef48dd989ffab08b123a6aada1933d37ba0685f70285f4fe3f12b9fd6afe1922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e50d00298a0380810c19d910c07711416344b4bca182868f86b981d2739c497"
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
