class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.8.1.tgz"
  sha256 "afeb1cf0b687a91bf29abc139a2ab74b3311e784e4f1b458a93a7fe3be6fd1ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cdbee20433d042ea7f541924211694e4046ce945fb59c5707978053afd117eb8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cdbee20433d042ea7f541924211694e4046ce945fb59c5707978053afd117eb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cdbee20433d042ea7f541924211694e4046ce945fb59c5707978053afd117eb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b5ae10ce3e99d89d9932e5f246fdc4a4ee16cccbc4333268b1b96401ab0df8cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b5ae10ce3e99d89d9932e5f246fdc4a4ee16cccbc4333268b1b96401ab0df8cb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
