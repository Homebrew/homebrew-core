class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.9.0.tgz"
  sha256 "9f248a84a314319c5afc2295a32d8223d8dc83a76308dc2e640c587fa769ec0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2b8f8f355f6dd9d2c43c0900cab6adef1ca2afb007c241a97f1c93b22f2ad967"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b8f8f355f6dd9d2c43c0900cab6adef1ca2afb007c241a97f1c93b22f2ad967"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2b8f8f355f6dd9d2c43c0900cab6adef1ca2afb007c241a97f1c93b22f2ad967"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "16f67a44d8bc52f4892a9d109ca0e8b5e5efed5b96e4a15de0a8474b9050a6ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "16f67a44d8bc52f4892a9d109ca0e8b5e5efed5b96e4a15de0a8474b9050a6ce"
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
