class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-9.0.0.tgz"
  sha256 "4f21e1cbdbbd1c6217a3bbc415e4fb2309eaf2ab8e3010016db98d17b0dd775b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0f051b35df7e720e8fcddddccc975d6887965d566a9956f83f73838b670eac80"
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
