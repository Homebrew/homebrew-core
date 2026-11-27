class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.16.0.tgz"
  sha256 "e4158f5259ffd9e19fa22573190b64b7c505ddb69f965f63c84e3cbb78411359"
  license "MIT"

  bottle do
    manifest_sha256 "9ba48a1d5e792009ecc5a8e077d2acd4f5ff91c632ee6ab49ee52108891530d4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "793d98d9bec70871584f5a7ef035a0ea846406d9e407037322c943aec2b7f61d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "793d98d9bec70871584f5a7ef035a0ea846406d9e407037322c943aec2b7f61d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "793d98d9bec70871584f5a7ef035a0ea846406d9e407037322c943aec2b7f61d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eb488eeb16ac4d4dc13f97bb9e236a1e96335b852f86172cae9a62822478104e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "eb488eeb16ac4d4dc13f97bb9e236a1e96335b852f86172cae9a62822478104e"
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
