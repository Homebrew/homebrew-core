class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.5.0.tgz"
  sha256 "28762e8a6a207e28678f1af8dcef39cdc625b1780a68ca1fa0ced033fd2a4e77"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "86eec290c64eb557f5979b83472afd528eabdde501bea0093ae3b88eb70c55fe"
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
