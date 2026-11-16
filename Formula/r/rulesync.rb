class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.8.3.tgz"
  sha256 "902b4f48b3221923982b124327a3709e894f6c73734d8c1dcf8c39e8852b45ab"
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
