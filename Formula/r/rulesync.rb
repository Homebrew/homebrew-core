class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.23.6.tgz"
  sha256 "577c2d8eec5b789146ad3d5cc4dba1c32ba44ea30947de8289db37fd39077bec"
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
