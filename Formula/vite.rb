require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.9.8.tgz"
  sha256 "a451ccec5df9b8033752b7d65534d783c91b1f23d84c0f5963d620b3de3692bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8059632f71b9344a944710c55538add4485b7f7e586a13b435c0b4322d367ab2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8059632f71b9344a944710c55538add4485b7f7e586a13b435c0b4322d367ab2"
    sha256 cellar: :any_skip_relocation, monterey:       "84dee5d5cfe74dcf103619ed98bdb3eb6bd3a51e2a09b10c8f3dbbfdb09c7be2"
    sha256 cellar: :any_skip_relocation, big_sur:        "84dee5d5cfe74dcf103619ed98bdb3eb6bd3a51e2a09b10c8f3dbbfdb09c7be2"
    sha256 cellar: :any_skip_relocation, catalina:       "84dee5d5cfe74dcf103619ed98bdb3eb6bd3a51e2a09b10c8f3dbbfdb09c7be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b11ba143ce1187e1ecab692c828ca24056e749e4a7ff3a85803c5f06b3112379"
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
