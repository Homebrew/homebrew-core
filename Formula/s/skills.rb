class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.7.6.tgz"
  sha256 "7ab1d2a52f1e0058d2f7d4f425821e6346ce90526304594f2275f008b816563e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ae77e16e96cb3a09159e973ac098d9966bd9867362a82d6c81ef9981c992cd57"
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
