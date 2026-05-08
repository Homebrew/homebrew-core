class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.5.5.tgz"
  sha256 "afa8b8fb739899250adb2f9d1cad309e17888690bb3542085b23636a1bb69380"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3fa59beaa1d19ae48c233d3d378bfc2dbd56ba4a362e1b08c038d2c1ba7b02ce"
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
