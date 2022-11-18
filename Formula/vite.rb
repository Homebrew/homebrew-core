require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.2.4.tgz"
  sha256 "f8c10824bdbe809e9a934de19d94c744d99d6736b0b3390ac19d40f663bc67ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d81d550785ed7e2286e865b7f2ae070295625bb3d07667ab73ff1450faa9052a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d81d550785ed7e2286e865b7f2ae070295625bb3d07667ab73ff1450faa9052a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d81d550785ed7e2286e865b7f2ae070295625bb3d07667ab73ff1450faa9052a"
    sha256 cellar: :any_skip_relocation, ventura:        "015c726b3a16d481386c4f729955b314c7fc5e1144ec76362c402f19cb9ddd2d"
    sha256 cellar: :any_skip_relocation, monterey:       "015c726b3a16d481386c4f729955b314c7fc5e1144ec76362c402f19cb9ddd2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "015c726b3a16d481386c4f729955b314c7fc5e1144ec76362c402f19cb9ddd2d"
    sha256 cellar: :any_skip_relocation, catalina:       "015c726b3a16d481386c4f729955b314c7fc5e1144ec76362c402f19cb9ddd2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac7b243b204b5bc647bb47e8f2c48255bb7dae4643b1e2c926ac5086704ec121"
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
