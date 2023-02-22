require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.1.4.tgz"
  sha256 "3d405f4ca588221be6e9ecfbd87dc4aa12cf9ad19b9095c341cc3cf88aa38d5b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6a6f0dea0f9a153f0eadb10b412ef832ba43138a95e32cf66b0fd4c5a031aa2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6a6f0dea0f9a153f0eadb10b412ef832ba43138a95e32cf66b0fd4c5a031aa2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6a6f0dea0f9a153f0eadb10b412ef832ba43138a95e32cf66b0fd4c5a031aa2"
    sha256 cellar: :any_skip_relocation, ventura:        "2fc5d44ab662c43fd15c168f90178573bde2304dc55b67d73f0c7a7d0007b6e3"
    sha256 cellar: :any_skip_relocation, monterey:       "2fc5d44ab662c43fd15c168f90178573bde2304dc55b67d73f0c7a7d0007b6e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2fc5d44ab662c43fd15c168f90178573bde2304dc55b67d73f0c7a7d0007b6e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73ea1401cb01c42ba6b1825a69a79c2d5f451bb7718b0eb624340e108e5e0b94"
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
