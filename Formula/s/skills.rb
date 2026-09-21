class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.7.0.tgz"
  sha256 "8d1466f792baaee945dae88e05ee403d6f9e78a3ae8dcbf61496035ca274418d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9e8e5e3f54bb3f64e483f090b8dd36a57eb40ee8e3957c50d3e074b04992a7ff"
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
