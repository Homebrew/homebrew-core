class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.5.13.tgz"
  sha256 "cab706c3cb1e06096c8b837823f5b49d0db427a0571194a1b90a0d58e4ae23a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "636d37ca399490b1add385c74ab13f6060839440b9b462f5ece315207c72a8a0"
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
