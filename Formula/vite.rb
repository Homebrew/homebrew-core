require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.1.1.tgz"
  sha256 "3c4fbf759ff8b7c1004103da4ca002cc27efb26acdf712b7f7a6e9100a836fb9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98ae9a3133013ea2bf0e95a750b1bc5cc5629fe3bc86b97ba6e824182ab39d38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98ae9a3133013ea2bf0e95a750b1bc5cc5629fe3bc86b97ba6e824182ab39d38"
    sha256 cellar: :any_skip_relocation, monterey:       "e319c15bdd8bb12eb10aa51f32780918618f641b2e80aa0e215bf5db7bb1f910"
    sha256 cellar: :any_skip_relocation, big_sur:        "e319c15bdd8bb12eb10aa51f32780918618f641b2e80aa0e215bf5db7bb1f910"
    sha256 cellar: :any_skip_relocation, catalina:       "e319c15bdd8bb12eb10aa51f32780918618f641b2e80aa0e215bf5db7bb1f910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5e90ce82044bae1ed64f6ac3aa7109e50940527032fa2bceaeef195daa4385d"
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
