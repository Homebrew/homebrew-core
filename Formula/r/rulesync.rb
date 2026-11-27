class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.16.0.tgz"
  sha256 "e4158f5259ffd9e19fa22573190b64b7c505ddb69f965f63c84e3cbb78411359"
  license "MIT"

  bottle do
    manifest_sha256 "56a2bfa1784e87b9b2dea9918aee2ce0c27f75db2e1e5e22fe4353e81078bef4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "275b0d14b44d7218a2d8ab51bd3f90bb753befc227c717cab5ac074eb394a9b5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "275b0d14b44d7218a2d8ab51bd3f90bb753befc227c717cab5ac074eb394a9b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "275b0d14b44d7218a2d8ab51bd3f90bb753befc227c717cab5ac074eb394a9b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fd364a2eec017e752b647e64dba7b41dd01def4d2eb9ffabce2d9bf453d98a5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fd364a2eec017e752b647e64dba7b41dd01def4d2eb9ffabce2d9bf453d98a5f"
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
