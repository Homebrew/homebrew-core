require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.7.11.tgz"
  sha256 "d8e3f4bb244f454103e2a17e49151150c9c33a63f89e42f8219866535b9dd028"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "834689084854d25543ed7c50a1301b3025c597bebcd1737def3554ed81f1b90c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "834689084854d25543ed7c50a1301b3025c597bebcd1737def3554ed81f1b90c"
    sha256 cellar: :any_skip_relocation, monterey:       "65fd591eb50f6d6e147e1c91d3022b26150dee6526c238fa36a43d30dab5fbe4"
    sha256 cellar: :any_skip_relocation, big_sur:        "65fd591eb50f6d6e147e1c91d3022b26150dee6526c238fa36a43d30dab5fbe4"
    sha256 cellar: :any_skip_relocation, catalina:       "65fd591eb50f6d6e147e1c91d3022b26150dee6526c238fa36a43d30dab5fbe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0ff02135fe97f6018c329985c117c738676fa18368cd843fead89400b4d7534"
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
