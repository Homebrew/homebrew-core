class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.15.0.tgz"
  sha256 "1a641d10c5558324440440bfa82bf896f12294c8ed61fbd9b83fbaf4f7f6c7ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8e433324fd113dd9eb0ecdda3e87c0b26be185384aa9602944309846b0c6c7c1"
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
