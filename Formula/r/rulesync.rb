class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.8.2.tgz"
  sha256 "340e182f251572241db0868d2e717d8f6caafbed3b02bea9647753fd36533491"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a69284efc80e531f10bd765f9531a3e04e525adcce0e16674485e4b6cc42de35"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a69284efc80e531f10bd765f9531a3e04e525adcce0e16674485e4b6cc42de35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a69284efc80e531f10bd765f9531a3e04e525adcce0e16674485e4b6cc42de35"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f2b14b1ac36f5d694ecfc2efed5fed1830da86feff1834b16c61e628aecb98fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f2b14b1ac36f5d694ecfc2efed5fed1830da86feff1834b16c61e628aecb98fd"
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
