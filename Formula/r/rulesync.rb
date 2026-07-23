class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-14.1.0.tgz"
  sha256 "4c92bcb4d7d7f56323c8a0ba23a7a2bad277cbcf3067454fe12e8d056ac4619f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b364577e4e91ba1da4083ea9f18a57e38561dfe2243f933500921bb823c35011"
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
