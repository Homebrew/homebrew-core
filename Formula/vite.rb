require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.1.7.tgz"
  sha256 "ba383539dc19f8d087267b569cf3f2481f1757b529bad13879fdbb97abf3c423"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df80ab1c0229f508aa2720597e0bf22fcfa9d09ad0a3e827cf5e307dc0b0ae1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df80ab1c0229f508aa2720597e0bf22fcfa9d09ad0a3e827cf5e307dc0b0ae1e"
    sha256 cellar: :any_skip_relocation, monterey:       "584c8fdc3cbb783caafbde76e1271ded838be33d08c6f0380e80aaaae498fdc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "584c8fdc3cbb783caafbde76e1271ded838be33d08c6f0380e80aaaae498fdc4"
    sha256 cellar: :any_skip_relocation, catalina:       "584c8fdc3cbb783caafbde76e1271ded838be33d08c6f0380e80aaaae498fdc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1f40683391ae1573e25c211e320dcd20a85f18be5fce113d38e61a6317eba0b"
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
