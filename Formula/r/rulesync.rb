class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.11.0.tgz"
  sha256 "8d74ef7cfc5433fdfc349780f9aafe1c9e935facfd624a92718d2b49d8f242f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2e4a457da77e45c8ae95f070f34d23a085a016821b025829030bc8017f36bfd0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
