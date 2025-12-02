class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-3.1.5.tgz"
  sha256 "169e2456ed631cf3e6a4b3fb04dee02a86eac1ddd75f94696606b21a665d5fe0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cda3e616ed51f5cdabbae2b0158a336fd6c0422e828b4c1c4bf9b7416d60f1e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cda3e616ed51f5cdabbae2b0158a336fd6c0422e828b4c1c4bf9b7416d60f1e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cda3e616ed51f5cdabbae2b0158a336fd6c0422e828b4c1c4bf9b7416d60f1e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0df4828c3e5220d25a9be572d889ecb933db4607b3ea410453aa004f567d9fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0163b8e12726662917d1d6b32a7b11100c75e49d2ccf1c3c9ce1d1f2b19a7bab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3b5d5c94eb719badfe7147f1799780bb5cb1e308cc52fa64d682ea216e3e491"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove binaries for other architectures and musl
    os = OS.linux? ? "linux" : "darwin"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    prebuilds = libexec/"lib/node_modules/tweakcc/node_modules/node-lief/prebuilds"
    prebuilds.children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "#{os}-#{arch}"
    end
    rm prebuilds/"#{os}-#{arch}/node-lief.musl.node" if OS.linux?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tweakcc --version")

    output = shell_output("#{bin}/tweakcc --apply 2>&1", 1)
    assert_match "Applying saved customizations to Claude Code", output
  end
end
