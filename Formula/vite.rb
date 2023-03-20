require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.2.1.tgz"
  sha256 "cb3f738fda80290ee42852fc2113a88e9a9731b1f5caa3648b45d33583bdbe3c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f632270f60384b5d87aa9d2c5812aa8f4c087b58239265c965997ced6746fd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f632270f60384b5d87aa9d2c5812aa8f4c087b58239265c965997ced6746fd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f632270f60384b5d87aa9d2c5812aa8f4c087b58239265c965997ced6746fd4"
    sha256 cellar: :any_skip_relocation, ventura:        "9a0311f27da60dcb19250dd42da5d854da691c9a5ab2b1bdd4e8f90c71613efc"
    sha256 cellar: :any_skip_relocation, monterey:       "9a0311f27da60dcb19250dd42da5d854da691c9a5ab2b1bdd4e8f90c71613efc"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a0311f27da60dcb19250dd42da5d854da691c9a5ab2b1bdd4e8f90c71613efc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90df556e53eccbe00635c2d95c929c8966ce864ca925d897ec4a50fc496593d4"
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
