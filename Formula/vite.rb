require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.3.5.tgz"
  sha256 "2b2c70a87e303f8b65d34c4372742a5e3016a53e1eb90ba6a83e4f55e8008c45"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36f6c8427e9f5109a8398de6930e73ace36eb0866c4779f2e3caad7d4c6a05a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36f6c8427e9f5109a8398de6930e73ace36eb0866c4779f2e3caad7d4c6a05a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36f6c8427e9f5109a8398de6930e73ace36eb0866c4779f2e3caad7d4c6a05a4"
    sha256 cellar: :any_skip_relocation, ventura:        "7be543fc899d0d1d1434a2a337399cac959ddfbe4281c77c87c60f1a85e7b5c0"
    sha256 cellar: :any_skip_relocation, monterey:       "7be543fc899d0d1d1434a2a337399cac959ddfbe4281c77c87c60f1a85e7b5c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "7be543fc899d0d1d1434a2a337399cac959ddfbe4281c77c87c60f1a85e7b5c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac786cd7d3ae86ece646e45e76d682ed3288f40f8f1b874494d785214396148f"
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
