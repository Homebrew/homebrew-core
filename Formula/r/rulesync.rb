class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.11.0.tgz"
  sha256 "77fb87e7a2c983692a99fa93009ff129fb2056819601a895c20f0a4ec1a78f27"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cb9f2159df866de8623e614c9dfcd9056c40c2ea5f23d3a7e61d1fa7e6012b21"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cb9f2159df866de8623e614c9dfcd9056c40c2ea5f23d3a7e61d1fa7e6012b21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cb9f2159df866de8623e614c9dfcd9056c40c2ea5f23d3a7e61d1fa7e6012b21"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "28088cd296798c14ea2c77fdaf79eddf2e0fdb7559c474b81fceace9983cce61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "28088cd296798c14ea2c77fdaf79eddf2e0fdb7559c474b81fceace9983cce61"
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
