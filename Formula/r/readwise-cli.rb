class ReadwiseCli < Formula
  desc "Command-line interface for Readwise and Reader"
  homepage "https://readwise.io/cli"
  url "https://registry.npmjs.org/@readwise/cli/-/cli-0.5.11.tgz"
  sha256 "d1d3fca556693813e6d38acab1346340625537d3c76642ef5d53dd4e6f8c390c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c840f24ca38b85e5c16633bd1b0f473726ef5c806a2eea1f76ba0bd34a609f49"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/readwise --version")

    system bin/"readwise", "config", "set", "readonly", "true"
    assert_match "true", shell_output("#{bin}/readwise config get readonly")
  end
end
