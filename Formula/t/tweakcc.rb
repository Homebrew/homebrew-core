class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-1.5.4.tgz"
  sha256 "f47568c04864e9097069d106f5fde74dec31d1bcac4bf11e25a96b37f123383f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1191166c0d8ea2ea807384f22121bb874c52a23e00fe539482b24b2c710192ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1191166c0d8ea2ea807384f22121bb874c52a23e00fe539482b24b2c710192ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1191166c0d8ea2ea807384f22121bb874c52a23e00fe539482b24b2c710192ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a9ad51e74a4ada97b2eec5428271e73abb9f74de5e34fb948dd3bea87fcba8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a9ad51e74a4ada97b2eec5428271e73abb9f74de5e34fb948dd3bea87fcba8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a9ad51e74a4ada97b2eec5428271e73abb9f74de5e34fb948dd3bea87fcba8b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tweakcc --version")

    output = shell_output("#{bin}/tweakcc --apply 2>&1", 1)
    assert_match "Applying saved customizations to Claude Code", output
  end
end
