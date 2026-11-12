class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.8.1.tgz"
  sha256 "e4757551dc15dc05a0bf12b74eccd29cba7d2b08221325661d083f8703f9db5e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9bb303576f523592f001f00498b53e8dc76800038126821350afad9f250d2730"
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
