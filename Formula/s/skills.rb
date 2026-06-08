class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.5.10.tgz"
  sha256 "1630c6e062512ab9b110bd79324a778fe4610146eada4977620e77046b8d3bf3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a1ef1493eb1e884a6bc1fb35e148bee52a0fbdd4be67d848f81abf52e3061597"
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
