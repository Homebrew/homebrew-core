class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.8.0.tgz"
  sha256 "203e6e8892192049078756737773ba83f44986c38ed08b08129dcb665d443097"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "70aaaed38f41f604e08b7dc21c0ede2fb82f6c2bf0cd5ed57125749098784fd0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70aaaed38f41f604e08b7dc21c0ede2fb82f6c2bf0cd5ed57125749098784fd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "70aaaed38f41f604e08b7dc21c0ede2fb82f6c2bf0cd5ed57125749098784fd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "510d0d5895411daea6844ff85a2b24af5416342f1c986f0c96bf329456f3dd32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "510d0d5895411daea6844ff85a2b24af5416342f1c986f0c96bf329456f3dd32"
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
