class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-3.0.1.tgz"
  sha256 "d6eb4db1cabc62da992bfbb373f8abe2eb04d7490fb7332180d485ff40bfbcca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4798bfec559745464168aba0d6047b1db1337495d27edb12a2acebebe3fc644d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4798bfec559745464168aba0d6047b1db1337495d27edb12a2acebebe3fc644d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4798bfec559745464168aba0d6047b1db1337495d27edb12a2acebebe3fc644d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e8c4a1bf31e09cb091860094bd11a00f69b1f0c2f5d2da672a2c48bc0b81edf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e8c4a1bf31e09cb091860094bd11a00f69b1f0c2f5d2da672a2c48bc0b81edf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e8c4a1bf31e09cb091860094bd11a00f69b1f0c2f5d2da672a2c48bc0b81edf"
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
