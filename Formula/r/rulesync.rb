class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.4.0.tgz"
  sha256 "dc7e141458f661fc7b854f565289423586cc18be32e1b9051afe41e43159e52d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "76b6039f8de08b6370e6548762097f8337ab7cac289fdfd67f1a3f684790a6e1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "76b6039f8de08b6370e6548762097f8337ab7cac289fdfd67f1a3f684790a6e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76b6039f8de08b6370e6548762097f8337ab7cac289fdfd67f1a3f684790a6e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "548d95627a1b8d8ffd7e82fe396097980087292fec8f7ce74207fa4182c80807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "548d95627a1b8d8ffd7e82fe396097980087292fec8f7ce74207fa4182c80807"
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
