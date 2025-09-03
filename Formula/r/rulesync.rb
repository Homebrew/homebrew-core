class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-0.68.1.tgz"
  sha256 "ec54c41316af99e14a80e07d7794ceba7da5083394b8dbd3922ac6ad2f42ccf7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1a7534454f21da61513829ca9a8e7fe0314c8fd4321d5fdce10023c405926444"
  end

  depends_on "node"

  def install
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
