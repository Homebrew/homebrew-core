class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.6.1.tgz"
  sha256 "9aa668fa20f4e615eab98f0f52a4970dd80f79ab8f07738a6ab9d0bc7b8e0358"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "034f3a264511e1924fa8b85f7ff6f3b3392827b421565949edf0299fe18086a0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "034f3a264511e1924fa8b85f7ff6f3b3392827b421565949edf0299fe18086a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "034f3a264511e1924fa8b85f7ff6f3b3392827b421565949edf0299fe18086a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "97c39196d25660ead14828555e491ea2585bfb2da909d1d73911fbd1d92bb8f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "97c39196d25660ead14828555e491ea2585bfb2da909d1d73911fbd1d92bb8f9"
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
