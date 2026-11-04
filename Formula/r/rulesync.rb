class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.5.0.tgz"
  sha256 "6713758e60f2937f5ae9e70d358acded9553c2ad340ab4fa6a417dcdd9f519d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cf3b85aeaa66aca3a1284f3e3dcaf596f6498bada013902f8f2f78172e5bf3f0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf3b85aeaa66aca3a1284f3e3dcaf596f6498bada013902f8f2f78172e5bf3f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cf3b85aeaa66aca3a1284f3e3dcaf596f6498bada013902f8f2f78172e5bf3f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "391a00f8236760f6843be2d6e8f1fc0331099c7aca0fe5a400dfac3c486a1184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "391a00f8236760f6843be2d6e8f1fc0331099c7aca0fe5a400dfac3c486a1184"
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
