class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.9.1.tgz"
  sha256 "39b21ab22d1c4712ff3e165e6946b08d3c0b2d5b33e3677d8fdc1f5cd5a50b83"
  license "MIT"

  bottle do
    manifest_sha256 "efd73ed3767074f09fcc9bb417fa7eaecfaa41d6d27d703c1e42f1c9d0cfb165"
    sha256 cellar: :any_skip_relocation, all: "ecc38669a342e387cf14cddc6402eb4816d41fb84db9070d5e65e71ff3e3215b"
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
