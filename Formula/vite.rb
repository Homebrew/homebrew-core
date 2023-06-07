require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.3.9.tgz"
  sha256 "9d817e873dedbd444c1a7d3d5c6755a69899c9c8e18dc85c58f1496739f1ab00"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4b516600fb1b6f8f6dd02c5030ba5f4cde11638004f369679da95065ea9b059"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4b516600fb1b6f8f6dd02c5030ba5f4cde11638004f369679da95065ea9b059"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4b516600fb1b6f8f6dd02c5030ba5f4cde11638004f369679da95065ea9b059"
    sha256 cellar: :any_skip_relocation, ventura:        "c5544a5fecc56f81046fdf7afe21b5ee667229396995ad38a918528b30b5130d"
    sha256 cellar: :any_skip_relocation, monterey:       "c5544a5fecc56f81046fdf7afe21b5ee667229396995ad38a918528b30b5130d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5544a5fecc56f81046fdf7afe21b5ee667229396995ad38a918528b30b5130d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36713fbd064de195778ab9cb792a06acff2cfb00e72b0e6730d0e2f25c7167f6"
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
