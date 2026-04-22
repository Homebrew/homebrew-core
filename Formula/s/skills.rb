class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.5.1.tgz"
  sha256 "c351b70fb3af3f36d1385883c42338c7fab35ccd8b19060fd0eca4d262422240"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ccd3ee66c47104842867129cb09612d8fd4eccd5fb404373325da6e56ae3d014"
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
