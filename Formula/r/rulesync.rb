class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-6.2.0.tgz"
  sha256 "83aab74bec97013fa2c51fa16108a1546f22652b5b30dc2a203e85f81d35a2ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a949536f388cb655ec2474a09677f5d24341ebc6eb4e7559b66dbbf2e6edbe93"
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
