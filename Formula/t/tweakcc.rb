class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-3.0.0.tgz"
  sha256 "3b708eb0a9376da92c36fb8d84126ebe33e4458e8c9b2a598ef2dcd4ed88051e"
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

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/tweakcc/node_modules"
    (node_modules/"node-lief/prebuilds/linux-x64/node-lief.musl.node").unlink
    libexec.glob("#{node_modules}/node-lief/prebuilds/*")
           .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tweakcc --version")

    output = shell_output("#{bin}/tweakcc --apply 2>&1", 1)
    assert_match "Applying saved customizations to Claude Code", output
  end
end
