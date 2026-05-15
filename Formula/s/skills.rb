class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.5.6.tgz"
  sha256 "7f8267150d4d19764ee3dec7308aae0924c530a8addaf9fc28ef2fcd64ac478d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2c1c25d6ef355b030b62d9bde7224398015b95f00cc58e7202ebfd2b12786366"
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
