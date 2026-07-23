class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.5.20.tgz"
  sha256 "359417194b4049eed6b5a80a3c3f57b82c75d48962d791a0efdf41b85cf52990"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "380534fc574a152a7cca859b161ef016f063a63ed26bbd8688e802db410f97c5"
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
