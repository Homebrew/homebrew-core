require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.9.0.tgz"
  sha256 "4c7e308f8359beb53588cc9e5b1d716b0fce3bfef00ddc5461f3a35e0ad9dc26"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae8923261bd5460971b024d409b94ecd28b72a19f466080e59dc3291185c4f64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae8923261bd5460971b024d409b94ecd28b72a19f466080e59dc3291185c4f64"
    sha256 cellar: :any_skip_relocation, monterey:       "c1b6e04d47ca26e219fb28652a4c9aa1fa280a6452fef9e7b087a2a787a1b5d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1b6e04d47ca26e219fb28652a4c9aa1fa280a6452fef9e7b087a2a787a1b5d3"
    sha256 cellar: :any_skip_relocation, catalina:       "c1b6e04d47ca26e219fb28652a4c9aa1fa280a6452fef9e7b087a2a787a1b5d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88e18ea27178824b99e76e1406917b6c2c56bda0e02df9fa87f831eabd211ec9"
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
