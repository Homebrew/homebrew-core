class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.28.1.tgz"
  sha256 "6f4bd98d2c1a7b25e9e85e5a00ccea863d7aee2e6136d180a7ded8ec08c4abeb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7dc63ad8a7bb5c742b831b622d2a65ce761c62f8a7e3b5b73996f299022d63b8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
