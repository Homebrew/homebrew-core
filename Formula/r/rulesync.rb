class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.4.1.tgz"
  sha256 "a45a7cb3ceeaa883fb2073fac29bc396ce3149e1e745a4c415780d7030a40d81"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c1f67b26eefdb12a8dcc6cc69033e0d1f54dc8d02043c223a667d66e3854a226"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c1f67b26eefdb12a8dcc6cc69033e0d1f54dc8d02043c223a667d66e3854a226"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c1f67b26eefdb12a8dcc6cc69033e0d1f54dc8d02043c223a667d66e3854a226"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6834fcf72ac3f5034b9af46eeb57d1966a6cdf807707fb241f88c98c68ce74c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6834fcf72ac3f5034b9af46eeb57d1966a6cdf807707fb241f88c98c68ce74c9"
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
