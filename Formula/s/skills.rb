class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.4.8.tgz"
  sha256 "43330da47b94dcecec38e85a60e06026c30358b8c2f0088b15eb5ee619650e3d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "175b937a14152ccd95736f4c8e9de9798dbae0cf787fcbb6d00fe28e0823a72d"
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
