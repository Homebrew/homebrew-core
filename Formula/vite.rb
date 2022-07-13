require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.0.0.tgz"
  sha256 "b7b364211b240e46192ef5cc9d0512492d216f3aa7c9d5f70a9eab43f7a850bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a85911941889d493cffc49e9021bf640a1b5d7ad80888007a9ad806d4a38b22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a85911941889d493cffc49e9021bf640a1b5d7ad80888007a9ad806d4a38b22"
    sha256 cellar: :any_skip_relocation, monterey:       "665c44c87669bd36244c2aeb21f3fe1c28f9f2a841ff845c21fccb3b6f2dbe53"
    sha256 cellar: :any_skip_relocation, big_sur:        "665c44c87669bd36244c2aeb21f3fe1c28f9f2a841ff845c21fccb3b6f2dbe53"
    sha256 cellar: :any_skip_relocation, catalina:       "665c44c87669bd36244c2aeb21f3fe1c28f9f2a841ff845c21fccb3b6f2dbe53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d0fdb7da37404ff158c0218718b4b776d12ea44469013f92e89505f5ad63ffb"
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
