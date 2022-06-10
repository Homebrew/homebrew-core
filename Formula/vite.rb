require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.9.11.tgz"
  sha256 "d2a2a5002a83dbd77ac0ec780dfc92c312f98a6b9c950e4c98d30279e6ed5549"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da7a9a379253340b24ecbf33fd1f699b2056ead5c1b92b66164d25f1ee8671a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da7a9a379253340b24ecbf33fd1f699b2056ead5c1b92b66164d25f1ee8671a4"
    sha256 cellar: :any_skip_relocation, monterey:       "7bf98a525642991b3b9347c2eaaf19e156ba378371c38b4808d05dcd808a7ee9"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bf98a525642991b3b9347c2eaaf19e156ba378371c38b4808d05dcd808a7ee9"
    sha256 cellar: :any_skip_relocation, catalina:       "7bf98a525642991b3b9347c2eaaf19e156ba378371c38b4808d05dcd808a7ee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15e3268d438fb987ff4af39197b8fcee8a1a461ccfa760ab2081ff1bb1e1bc57"
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
