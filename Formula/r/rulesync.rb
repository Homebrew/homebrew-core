class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.9.1.tgz"
  sha256 "e4748286d2c6a3126df92fbeba26d3b0450c9cbcb3d3670334f5f9eaba5bac80"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e5d70da85b809d7ca2994882742f23005fb8ccde764c36774b1375ca0f8d0ffe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e5d70da85b809d7ca2994882742f23005fb8ccde764c36774b1375ca0f8d0ffe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e5d70da85b809d7ca2994882742f23005fb8ccde764c36774b1375ca0f8d0ffe"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3eabedc1e345bda6cf130eaa27a6f795c178b761fef0fe8d203f34872d9c576b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3eabedc1e345bda6cf130eaa27a6f795c178b761fef0fe8d203f34872d9c576b"
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
