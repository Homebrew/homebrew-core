class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.9.1.tgz"
  sha256 "39b21ab22d1c4712ff3e165e6946b08d3c0b2d5b33e3677d8fdc1f5cd5a50b83"
  license "MIT"

  bottle do
    manifest_sha256 "b419aa6258f0edf2ecc3844e7c93b243c964d91ca1cac4b588bc45d6a8649223"
    sha256 cellar: :any_skip_relocation, all: "fc21155e78e433560767ed15573799914fe72328061b7ac7262a0fcdf3022f7c"
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
