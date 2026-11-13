class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.8.1.tgz"
  sha256 "afeb1cf0b687a91bf29abc139a2ab74b3311e784e4f1b458a93a7fe3be6fd1ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e294646f07b6db1a0e03620e7528cc5087bda4f97bfb203b6f07f790b6e4ba98"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e294646f07b6db1a0e03620e7528cc5087bda4f97bfb203b6f07f790b6e4ba98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e294646f07b6db1a0e03620e7528cc5087bda4f97bfb203b6f07f790b6e4ba98"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "05a68002ff8a05f6ec0bad52787fb348633ebf726e2a29445f796cf9bf1e2389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "05a68002ff8a05f6ec0bad52787fb348633ebf726e2a29445f796cf9bf1e2389"
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
