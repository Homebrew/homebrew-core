class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-1.1.0.tgz"
  sha256 "b09599584f415c3063847e1fe70eafa77e29873a700c6d8bdfeca31510165282"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bfdd4fc4ba43f88fd16872d0527cc2fb4551efd6a9bb1b1e023d91a4456004f9"
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
