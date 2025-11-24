class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.24.0.tgz"
  sha256 "4bc5daa3e424a02da9dedf9164269ddf0c311e3ec8cedca3e2013f09775efb94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5d56de0f9a1bca21c6f151edf3a5d5e0836a5686f79b0bf6b3278e3dbbc291f5"
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
