require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.3.1.tgz"
  sha256 "79c59565bea112f6bc63dd9ec7da472e656994e2b0d8928a92df8ffd9f587292"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f008f11735a65ff51775e2600e2b5b96b01ae29af5b9c6d4b92c617d8dc513d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f008f11735a65ff51775e2600e2b5b96b01ae29af5b9c6d4b92c617d8dc513d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f008f11735a65ff51775e2600e2b5b96b01ae29af5b9c6d4b92c617d8dc513d"
    sha256 cellar: :any_skip_relocation, ventura:        "fdf2ade46cc90967d983a5c7e2ad48a3bc0b75b255dfea0186242134e2428b0a"
    sha256 cellar: :any_skip_relocation, monterey:       "fdf2ade46cc90967d983a5c7e2ad48a3bc0b75b255dfea0186242134e2428b0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdf2ade46cc90967d983a5c7e2ad48a3bc0b75b255dfea0186242134e2428b0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52dbe35655fbc58f839f9f6f90db2aa368e200c944fb0fd8df6ad8a27cf85e20"
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
