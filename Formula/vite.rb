require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.6.1.tgz"
  sha256 "f01eeeb778e1c3f375a364d5ddd4b202b44933870329bd01fd308437334505c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "762abca9bfaee4ba59d906af77e24c81f9ca6cd0c931a5e6cfc7dcef0716d105"
    sha256 cellar: :any_skip_relocation, big_sur:       "9efcd67353fd6ad1cdb4c7557d302ad0b5bba039cc2eed9b5c8395e71fa0488a"
    sha256 cellar: :any_skip_relocation, catalina:      "9efcd67353fd6ad1cdb4c7557d302ad0b5bba039cc2eed9b5c8395e71fa0488a"
    sha256 cellar: :any_skip_relocation, mojave:        "9efcd67353fd6ad1cdb4c7557d302ad0b5bba039cc2eed9b5c8395e71fa0488a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "805b6fea064efd2fc425e3b5f8a7697208407453daafe438cb067e4930205e80"
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
