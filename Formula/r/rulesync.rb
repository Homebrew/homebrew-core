class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.10.1.tgz"
  sha256 "41fedd73643a2351d6de6c504eab92862046b95c44e1c8ac072d1bd18ac1ee0e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5aad316f9b6b1b2d9b13cb31c9c9efe113b763420dcb10acf4a70e7fb7d77f0b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5aad316f9b6b1b2d9b13cb31c9c9efe113b763420dcb10acf4a70e7fb7d77f0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5aad316f9b6b1b2d9b13cb31c9c9efe113b763420dcb10acf4a70e7fb7d77f0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "10cb20c113319a093af6838ee85b7f69435a2626132202cb17a7b7a0a5c2a7b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "10cb20c113319a093af6838ee85b7f69435a2626132202cb17a7b7a0a5c2a7b0"
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
