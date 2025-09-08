class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-0.71.0.tgz"
  sha256 "642428f861247b62f48b0cad8b04d44c056780f09ef297297372701ecf757e4b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "69079978608b7a0ab3327fc59dc79839819d8a9bc4a300a4652236689791f317"
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
