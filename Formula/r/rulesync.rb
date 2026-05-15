class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.17.0.tgz"
  sha256 "1a0b99788045f5cb3be5123b2ce068549e2afffd4bd715827f8834faad231307"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e1b24e1da4b4d43877f4e37c59cbd7e7d8b48779ce3458b365f50ff10d18b8da"
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
