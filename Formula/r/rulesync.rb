class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.14.0.tgz"
  sha256 "ed0f088284802b75b548fc43bf34fa9a5429470b5255598989be105003635cc4"
  license "MIT"

  bottle do
    manifest_sha256 "014b74a9eafbadee402ddee3c48bebd98029631e99a995401b6f7359b6b6a06a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4d2ae9ad25f2ee72012af5de250a2765c75b998ccabb6f425c3a9368ec7cb178"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4d2ae9ad25f2ee72012af5de250a2765c75b998ccabb6f425c3a9368ec7cb178"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4d2ae9ad25f2ee72012af5de250a2765c75b998ccabb6f425c3a9368ec7cb178"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ecbb595fbd06e78894089b145590ae8094cd8abe5529b6df21339a2400682b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ecbb595fbd06e78894089b145590ae8094cd8abe5529b6df21339a2400682b49"
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
