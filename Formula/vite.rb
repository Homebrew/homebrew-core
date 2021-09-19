require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.5.9.tgz"
  sha256 "5326e22aad54e7d873827410b6dd7988a71176d49d5023ebc89a54fc4c4f831f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d28714a45f958e953591f4d085376f22d962b57e673959a8a8dcf89bcdd45db8"
    sha256 cellar: :any_skip_relocation, big_sur:       "03631c9c86dd01c81e340ccdb738c5096566cbd36952bf61ff6ed6eb8628d33c"
    sha256 cellar: :any_skip_relocation, catalina:      "03631c9c86dd01c81e340ccdb738c5096566cbd36952bf61ff6ed6eb8628d33c"
    sha256 cellar: :any_skip_relocation, mojave:        "03631c9c86dd01c81e340ccdb738c5096566cbd36952bf61ff6ed6eb8628d33c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d63c1a3dae6b79e9c9f0c16d6bf0161323a31db33c4538f2391e56bb0195a2cf"
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
