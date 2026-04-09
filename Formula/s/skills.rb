class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.4.9.tgz"
  sha256 "5acffeff29929296a00a9be6d7b32fbe4dceb58b444af48501cab1e6c90ce377"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b77d8fe19e8461f4740591de663be008a48833b5de52b62b0896651fad40a63c"
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
