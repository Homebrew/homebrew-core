require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.0.2.tgz"
  sha256 "0a44b266f5a5f9ae9d6b3a1d78d4308b28bf767f20d124f56b2999c637393d07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf3c0cf86022ee5835a5f1d1c200e3bc52d7668165c55f61d1e9dac5d1451e24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf3c0cf86022ee5835a5f1d1c200e3bc52d7668165c55f61d1e9dac5d1451e24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf3c0cf86022ee5835a5f1d1c200e3bc52d7668165c55f61d1e9dac5d1451e24"
    sha256 cellar: :any_skip_relocation, ventura:        "d850950f4c7ebd8eb07ca59e7c4c61c440cc14c2b630c8d1c6161ed4c065568c"
    sha256 cellar: :any_skip_relocation, monterey:       "d850950f4c7ebd8eb07ca59e7c4c61c440cc14c2b630c8d1c6161ed4c065568c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d850950f4c7ebd8eb07ca59e7c4c61c440cc14c2b630c8d1c6161ed4c065568c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1a6986e9e47304268026eb5c9d2f66fba5ab2ed0a086f5212edc8d6cf570f1c"
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
