class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.23.3.tgz"
  sha256 "86be5925144914561adb6ef461a20d8b6167d28f0a23b411e936079f773402fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "41e20e1cca521f3463bcce65dbfb18a0e0418c775559a43fb84241ca1c0b9531"
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
