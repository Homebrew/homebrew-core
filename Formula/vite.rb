require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.9.14.tgz"
  sha256 "6b26d350840d9393203f27192adaad78ac664708b86c076f77cbf8130d557a91"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e7014b0592de02118f3a97637419ad292bc8b6a86fb7f736f8df5cd24156188"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e7014b0592de02118f3a97637419ad292bc8b6a86fb7f736f8df5cd24156188"
    sha256 cellar: :any_skip_relocation, monterey:       "3121e51e211898847e99629ab73c2ed4413dcc87b219a8b927b7aee35c1c8cc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "3121e51e211898847e99629ab73c2ed4413dcc87b219a8b927b7aee35c1c8cc0"
    sha256 cellar: :any_skip_relocation, catalina:       "3121e51e211898847e99629ab73c2ed4413dcc87b219a8b927b7aee35c1c8cc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91ecf11733fae9f696c4048921e931cf8a800c3daf62d0bd0738303e07ed4691"
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
