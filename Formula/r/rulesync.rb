class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.28.0.tgz"
  sha256 "857943ddc068e65a8bdf1550fbe5485ff490b18a5f6de891b5ae9124150e6979"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "543c0868899ce6acb29eb8c27176c226a830ac2cc4dbac9fa7e9a43d062f6b0b"
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
