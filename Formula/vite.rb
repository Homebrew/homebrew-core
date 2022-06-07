require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.9.10.tgz"
  sha256 "e2e832cd43260f0f159d37a12a82fea99d715c69c142d840619c6a1c42921c68"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5f64191652686db6fe4d8a2b603407af0b4c7c0774dc25a6308b6d5a698f968"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5f64191652686db6fe4d8a2b603407af0b4c7c0774dc25a6308b6d5a698f968"
    sha256 cellar: :any_skip_relocation, monterey:       "6407d946c0f86470282ddfa1a9aec06df64fbfeb4c4d1b272f17c8c3c3619a56"
    sha256 cellar: :any_skip_relocation, big_sur:        "6407d946c0f86470282ddfa1a9aec06df64fbfeb4c4d1b272f17c8c3c3619a56"
    sha256 cellar: :any_skip_relocation, catalina:       "6407d946c0f86470282ddfa1a9aec06df64fbfeb4c4d1b272f17c8c3c3619a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4946473487e8371c4099d169de866ba2618f7c0c53127541d268dd796f4da185"
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
