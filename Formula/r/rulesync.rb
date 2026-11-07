class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.6.3.tgz"
  sha256 "e9044c96b016983cf6391421f634b8ca1611f82eac042368492a9db9f2fa9308"
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
