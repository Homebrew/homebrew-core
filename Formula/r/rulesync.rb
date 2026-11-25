class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.13.0.tgz"
  sha256 "d1081345d57568140722fa295e87891aa79f960349bf81c89ec65f5eabb43c65"
  license "MIT"

  bottle do
    manifest_sha256 "93c9fe6a0800c517616208909cc2eef2241a72083e7a0d1856988e80c04fc218"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2237521eea7f54a390a274cea83ad974978c2e7d43fa7224bc156490cade5d2b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2237521eea7f54a390a274cea83ad974978c2e7d43fa7224bc156490cade5d2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2237521eea7f54a390a274cea83ad974978c2e7d43fa7224bc156490cade5d2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f7cbd38ded626170af2b05396364d5ac7f307eeb0c27a43a142a8c464c746374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f7cbd38ded626170af2b05396364d5ac7f307eeb0c27a43a142a8c464c746374"
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
