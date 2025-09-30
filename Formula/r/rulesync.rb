class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-1.2.6.tgz"
  sha256 "b1720c9d5d503be533d86d1f9683a46ced635762b4a7081cfb006928e8623deb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a1b065de45ed2d5b88f666ec0408b7b82d2aecfea70e8130628e010063c4df3e"
  end

  depends_on "node"

  def install
    # version patch, upstream pr ref, https://github.com/dyoshikawa/rulesync/pull/324
    inreplace "dist/index.js", "1.2.5", version.to_s

    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
