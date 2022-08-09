require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.0.5.tgz"
  sha256 "870e18b4bd8b3010ec1a67dee12deb85eddc170101e83f31233eda0aa8130b6f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea2e0947d614113b5fc59b6df3c2e9572c0c88a13b3c6926d0fa84e5a86a3ee5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea2e0947d614113b5fc59b6df3c2e9572c0c88a13b3c6926d0fa84e5a86a3ee5"
    sha256 cellar: :any_skip_relocation, monterey:       "1ec2bb1dd2c946f57a4dbf7fff24dc8f43a70a1e14f5b9beca3b515be10f34c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ec2bb1dd2c946f57a4dbf7fff24dc8f43a70a1e14f5b9beca3b515be10f34c0"
    sha256 cellar: :any_skip_relocation, catalina:       "1ec2bb1dd2c946f57a4dbf7fff24dc8f43a70a1e14f5b9beca3b515be10f34c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24f21201f6e4a5e1c4200e9b122c5986c28a455743440da3d102cf72257f7d16"
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
