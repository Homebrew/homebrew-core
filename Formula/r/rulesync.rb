class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.30.2.tgz"
  sha256 "4347e96d17fae1f99f61bad35a01623281a24e36c6d2ceaae08a000cac7ae854"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "22f372707da68352ae71009fb79a8bf1e3af4c7f906ea5271f6421ce82a964aa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "22f372707da68352ae71009fb79a8bf1e3af4c7f906ea5271f6421ce82a964aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "22f372707da68352ae71009fb79a8bf1e3af4c7f906ea5271f6421ce82a964aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3a22a0a510acef451a5b9c4a400c2be1cc8d3f1c026760dd2cfd6e14ad7869b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3a22a0a510acef451a5b9c4a400c2be1cc8d3f1c026760dd2cfd6e14ad7869b3"
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
