require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.7.12.tgz"
  sha256 "370466e6e1829cd6b0467324e5377a443d4d191b63ceae4092302018f68348d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3159361d7bb9e7205ab201205f89548efcd866b2b522b188e1079ae13808c279"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3159361d7bb9e7205ab201205f89548efcd866b2b522b188e1079ae13808c279"
    sha256 cellar: :any_skip_relocation, monterey:       "41b42d5fa21864733928908b43aa1d1baf2abc6ad800a76913fee38c1e7e262a"
    sha256 cellar: :any_skip_relocation, big_sur:        "41b42d5fa21864733928908b43aa1d1baf2abc6ad800a76913fee38c1e7e262a"
    sha256 cellar: :any_skip_relocation, catalina:       "41b42d5fa21864733928908b43aa1d1baf2abc6ad800a76913fee38c1e7e262a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51b2d1d79ce3b4df3652b089d3031da35b45bd923a8bbcef20b33c5a1cabb691"
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
