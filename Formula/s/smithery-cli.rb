class SmitheryCli < Formula
  desc "Install and list Model Context Protocol servers from Smithery"
  homepage "https://smithery.ai/"
  url "https://registry.npmjs.org/@smithery/cli/-/cli-4.11.1.tgz"
  sha256 "2d3a60fbbd9c2db4ffe80e806afa2075620a3b18b4a80cb26eb48501d76dfd3e"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7953d52a012f6401ce602007ddf769460798fc32feb2e35a60ca9c64e897ee27"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smithery --version")

    # `mcp list` reaches the real listing path, which requires authentication.
    assert_match "No API key found", shell_output("#{bin}/smithery mcp list 2>&1", 1)
  end
end
