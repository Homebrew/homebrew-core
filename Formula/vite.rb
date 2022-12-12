require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.0.1.tgz"
  sha256 "fe79c62cd8e871ee9d0166d8a6a1ba67706b8b330c596bf9715c23e0f0c760d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ef2436dbee94a6484680f43aad6d0ac6c5fdb3fe8e964ad9d65d1f5f23b7f7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ef2436dbee94a6484680f43aad6d0ac6c5fdb3fe8e964ad9d65d1f5f23b7f7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ef2436dbee94a6484680f43aad6d0ac6c5fdb3fe8e964ad9d65d1f5f23b7f7d"
    sha256 cellar: :any_skip_relocation, ventura:        "5f71dafdce9327083293e2a3da3f0d1eb206dc732e4044b50800faf0e101865f"
    sha256 cellar: :any_skip_relocation, monterey:       "5f71dafdce9327083293e2a3da3f0d1eb206dc732e4044b50800faf0e101865f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f71dafdce9327083293e2a3da3f0d1eb206dc732e4044b50800faf0e101865f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55789544ce7b5bf0ccb707e67f2a00dfbf5094f1b5ca3d67d8f943d293cb3216"
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
