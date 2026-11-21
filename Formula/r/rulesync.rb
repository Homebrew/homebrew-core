class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.10.1.tgz"
  sha256 "41fedd73643a2351d6de6c504eab92862046b95c44e1c8ac072d1bd18ac1ee0e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c64fa1f8127b0e13ff864b10083b27b208c6b0fe3d03a085775e9531489cc0d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c64fa1f8127b0e13ff864b10083b27b208c6b0fe3d03a085775e9531489cc0d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c64fa1f8127b0e13ff864b10083b27b208c6b0fe3d03a085775e9531489cc0d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bbdc3e2b790fbfc1b060997c597c8dda92839e4ea8c81fb6d5f6bf9349d10f1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bbdc3e2b790fbfc1b060997c597c8dda92839e4ea8c81fb6d5f6bf9349d10f1d"
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
