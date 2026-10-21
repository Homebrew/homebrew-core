class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.7.4.tgz"
  sha256 "fee71731971e94d90bff2ee55f5556dc325e2f6f53ca0b5eff93ed22b9d838dd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1eef86f16cbd3f34fa0bf04a36b9aabe0c486b4aa6da5d01cd38a0d2ea906156"
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
