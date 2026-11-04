class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.6.0.tgz"
  sha256 "301f119385a211a144c47d2042af76536d2d0bc1c8983abd66149ba6beaaee62"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "99dbf3fcec3d5ba301dfcd68f578904c43661b2a0a9843e774629def4d8692d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "99dbf3fcec3d5ba301dfcd68f578904c43661b2a0a9843e774629def4d8692d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "99dbf3fcec3d5ba301dfcd68f578904c43661b2a0a9843e774629def4d8692d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f1d048174a4c7e0684df2387e760126d791fc1585b7e97aa00a23969a27515d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f1d048174a4c7e0684df2387e760126d791fc1585b7e97aa00a23969a27515d3"
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
