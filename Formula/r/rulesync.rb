class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-38.0.0.tgz"
  sha256 "f44136507282267ddda4b2559813f6e1f4337fe54813c087764a84fcfce335f0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "67f9f129ab52687e060f8bb26c2a6d4f632eded7612266c8601c8f85f79c3d6c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "67f9f129ab52687e060f8bb26c2a6d4f632eded7612266c8601c8f85f79c3d6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "67f9f129ab52687e060f8bb26c2a6d4f632eded7612266c8601c8f85f79c3d6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1078e29deaa9b42a27bc6b54e84943f7f33c41e716bd095d567e69c5588330bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1078e29deaa9b42a27bc6b54e84943f7f33c41e716bd095d567e69c5588330bf"
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
