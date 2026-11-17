class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.9.0.tgz"
  sha256 "9f248a84a314319c5afc2295a32d8223d8dc83a76308dc2e640c587fa769ec0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1b743303f2526ba5ec5a01ed85110c04897b0bbbbc51513c08f38724c042d6ef"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1b743303f2526ba5ec5a01ed85110c04897b0bbbbc51513c08f38724c042d6ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1b743303f2526ba5ec5a01ed85110c04897b0bbbbc51513c08f38724c042d6ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "52c931a02a7476b42f75cc26fa993fc7d14450b73954e982ee117139fa869a3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "52c931a02a7476b42f75cc26fa993fc7d14450b73954e982ee117139fa869a3b"
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
