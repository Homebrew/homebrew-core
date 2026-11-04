class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.6.0.tgz"
  sha256 "301f119385a211a144c47d2042af76536d2d0bc1c8983abd66149ba6beaaee62"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aee969c2522249e22d136f655182bbd1cf420ef89a9dc48512f990329e8f999e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aee969c2522249e22d136f655182bbd1cf420ef89a9dc48512f990329e8f999e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aee969c2522249e22d136f655182bbd1cf420ef89a9dc48512f990329e8f999e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d8f70cddede9f6cf6faedbecfff532e26d3b1c6bc9b74bd367ca3bbaa17278f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d8f70cddede9f6cf6faedbecfff532e26d3b1c6bc9b74bd367ca3bbaa17278f5"
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
