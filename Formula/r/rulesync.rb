class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.24.1.tgz"
  sha256 "3bdd12fe7d2db255382beee2ecf419dfe830fb4cc5d85b6d9cf512eb2fd640e6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b8c3232bddaa55350408ad0d90413bddbcf57596c46a505c9cf42ca9465bfc58"
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
