require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.9.6.tgz"
  sha256 "d9dad599f0597c780a74da1e8210febd97dcc88764e6b0cbcae1f71c82b04e7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a251832bc493b681edb4867099c33b60c9b666a0f89ce17e874d749719587a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a251832bc493b681edb4867099c33b60c9b666a0f89ce17e874d749719587a1"
    sha256 cellar: :any_skip_relocation, monterey:       "07f6c742a43dc6c2df0b3e0f7798f21ba507cd58c7e633817766b4e55a9b6772"
    sha256 cellar: :any_skip_relocation, big_sur:        "07f6c742a43dc6c2df0b3e0f7798f21ba507cd58c7e633817766b4e55a9b6772"
    sha256 cellar: :any_skip_relocation, catalina:       "07f6c742a43dc6c2df0b3e0f7798f21ba507cd58c7e633817766b4e55a9b6772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e49f44c178252939f7d36e2e9a61e0b6ab1a49af6e28e1fb2edd438cbe1bd0bf"
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
