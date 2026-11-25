class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.13.0.tgz"
  sha256 "d1081345d57568140722fa295e87891aa79f960349bf81c89ec65f5eabb43c65"
  license "MIT"

  bottle do
    manifest_sha256 "2e6bdce3e729ae54114dddf1fcbba2fb8e24035e899701c6b661cb16d440d05b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9cebeaf1dc030c5aca14d80e6a8649e3eea0ef5c31f8a3538307b4659df349bf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9cebeaf1dc030c5aca14d80e6a8649e3eea0ef5c31f8a3538307b4659df349bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9cebeaf1dc030c5aca14d80e6a8649e3eea0ef5c31f8a3538307b4659df349bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "73bf8ed0c95350eb4ac74e354f1ddb7802582f5b16110dd15674a70841a00c7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "73bf8ed0c95350eb4ac74e354f1ddb7802582f5b16110dd15674a70841a00c7e"
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
