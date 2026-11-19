class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.9.2.tgz"
  sha256 "18464183281ce1ef51c9ef9440445a27a384983e7224b6b8143f15b1d7d4fbc8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c13889da4ea33831416d49b9a27704fc8d16b6bc158ad4ea635101bc16f54807"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c13889da4ea33831416d49b9a27704fc8d16b6bc158ad4ea635101bc16f54807"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c13889da4ea33831416d49b9a27704fc8d16b6bc158ad4ea635101bc16f54807"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ac16670ad9a76f0282b8b2eb7dfdc12776f220119bb4a65e2c6db7a30d79e693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ac16670ad9a76f0282b8b2eb7dfdc12776f220119bb4a65e2c6db7a30d79e693"
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
