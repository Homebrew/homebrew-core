class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-5.3.0.tgz"
  sha256 "d0cb753fe6f7a9f73047f15ae4537fae15d370034b7d3bea81436984bc493e8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "53dd4a7f6273e2a65f325b7db989c6fb18de54ec642f44917e2f0d45a436f964"
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
