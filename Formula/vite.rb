require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.8.1.tgz"
  sha256 "04a4bfc790e41490830c5df979c8a981411f841bae1ee822569dd9a22c11541a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be7f7ff7518b2d99ba6c0b3dcccb4fac3e01dde8d48f007e7db60ab24bddbd91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be7f7ff7518b2d99ba6c0b3dcccb4fac3e01dde8d48f007e7db60ab24bddbd91"
    sha256 cellar: :any_skip_relocation, monterey:       "67ab3d2dbbf9881dde5bbe1c20f4918dd34026533e4265beec0d38b209917204"
    sha256 cellar: :any_skip_relocation, big_sur:        "67ab3d2dbbf9881dde5bbe1c20f4918dd34026533e4265beec0d38b209917204"
    sha256 cellar: :any_skip_relocation, catalina:       "67ab3d2dbbf9881dde5bbe1c20f4918dd34026533e4265beec0d38b209917204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ffa4457b19db3ebed5b155a8bc62ab7ec6d844868c9318c5d4aaded898ee8bc"
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
