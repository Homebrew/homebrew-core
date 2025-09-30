class Seam < Formula
  desc "This utility lets you control Seam resources"
  homepage "https://github.com/seamapi/seam-cli"
  url "https://registry.npmjs.org/seam-cli/-/seam-cli-0.0.61.tgz"
  sha256 "64135eb8de1ddbc5190379088a34f87927b2e803a9bb71ce47cf1d873b1d94a0"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "e78f5c486295d6805811e6a48f3f0a1443706bc5d98430f3f860fc3ae84d8c99"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Build an `:all` bottle by removing workflow files
    node_modules = libexec/"lib/node_modules"
    rm_r node_modules/"seam-cli/ldid/.github"
  end

  test do
    system bin/"seam", "config", "set", "fake-server"
    output = shell_output("#{bin}/seam health get_health")
    assert_match "I’m one with the Force. The Force is with me.", output
  end
end
