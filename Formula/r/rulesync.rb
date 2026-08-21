class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.14.0.tgz"
  sha256 "10552ba03470eea79ba7ed189b0029bc9339ea89d35017f6ed371a7e5a38b062"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7263ad944011f016d9e7fbd29e2300071252a8c3cf27ccaaccae793d11a562fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7263ad944011f016d9e7fbd29e2300071252a8c3cf27ccaaccae793d11a562fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7263ad944011f016d9e7fbd29e2300071252a8c3cf27ccaaccae793d11a562fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "789cd512da402d1d8c3c95bc277871db0c45a55d4282d3d530ebbce44275d46f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "789cd512da402d1d8c3c95bc277871db0c45a55d4282d3d530ebbce44275d46f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "789cd512da402d1d8c3c95bc277871db0c45a55d4282d3d530ebbce44275d46f"
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
