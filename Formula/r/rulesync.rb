class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.7.0.tgz"
  sha256 "812c7b2d7ec63baee776159d5e9a7a796439178ef2ac50193a2bdccc9bef4ca0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e83a997402f1d7da69c4393ff310eeebc25755be0389e10c2a59248f28b3c825"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e83a997402f1d7da69c4393ff310eeebc25755be0389e10c2a59248f28b3c825"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e83a997402f1d7da69c4393ff310eeebc25755be0389e10c2a59248f28b3c825"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7c61adf3609eed18f6ae0d465938ea489e72c3969bedc6b3f5cdc07ec8bdc377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7c61adf3609eed18f6ae0d465938ea489e72c3969bedc6b3f5cdc07ec8bdc377"
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
