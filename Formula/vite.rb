require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.8.1.tgz"
  sha256 "04a4bfc790e41490830c5df979c8a981411f841bae1ee822569dd9a22c11541a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "875ae7bc78ec36b39e12c6f2808849a994889f3e3dcc36f25b0120455365a9f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "875ae7bc78ec36b39e12c6f2808849a994889f3e3dcc36f25b0120455365a9f4"
    sha256 cellar: :any_skip_relocation, monterey:       "5a6f400eeb5f0f699bdf74641f3ba67708abf0d54a59ff49be948318df4bfad7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a6f400eeb5f0f699bdf74641f3ba67708abf0d54a59ff49be948318df4bfad7"
    sha256 cellar: :any_skip_relocation, catalina:       "5a6f400eeb5f0f699bdf74641f3ba67708abf0d54a59ff49be948318df4bfad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "058859607dd4d3e92e71e0a5d3eab89861615398a8ee834702686c775cab03e0"
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
