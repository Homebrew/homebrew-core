class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.6.2.tgz"
  sha256 "1e8f9447bf13f2622127275c6e6d4e98d9250a4471a3c856327fc5eff0df792f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a736ad5ee0510e9cc3f2e9804e163cbfbba0792a4ecb05644e01dcff630b9f68"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a736ad5ee0510e9cc3f2e9804e163cbfbba0792a4ecb05644e01dcff630b9f68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a736ad5ee0510e9cc3f2e9804e163cbfbba0792a4ecb05644e01dcff630b9f68"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5837948a4730da527e6decd56954ca22dbc9a5a13f7702c81064df0ede6be16f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5837948a4730da527e6decd56954ca22dbc9a5a13f7702c81064df0ede6be16f"
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
