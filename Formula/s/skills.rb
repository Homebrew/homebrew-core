class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.7.5.tgz"
  sha256 "361b59d4eeaec304480e1f31180cf4783743256dda1beaebd2192c1671dd6c1f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4da71d8a755c1d89678fd1be434f9da5eb4d3ed55764e8f1bcc75140f4afc730"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skills --version")
    assert_match "No project skills found", shell_output("#{bin}/skills list")
    system bin/"skills", "init", "test-skill"
    assert_path_exists testpath/"test-skill/SKILL.md"
  end
end
