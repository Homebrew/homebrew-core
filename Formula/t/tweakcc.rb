class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-4.3.2.tgz"
  sha256 "027a63b7de5a2bec5f9dba9747d01a21649c91c7cceadcf997f4d1f61ff1db55"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3e21bfbe82e2ba114a965a8b89db04bb094e5d1a69ed2c95a3c74e1ac7fbdd4e"
    sha256 cellar: :any,                 arm64_sequoia: "3e21bfbe82e2ba114a965a8b89db04bb094e5d1a69ed2c95a3c74e1ac7fbdd4e"
    sha256 cellar: :any,                 arm64_sonoma:  "3e21bfbe82e2ba114a965a8b89db04bb094e5d1a69ed2c95a3c74e1ac7fbdd4e"
    sha256 cellar: :any,                 sonoma:        "bc670ac05ab5565af2520089dcf8e6e1975e73abe4fbe2b97dfd6d6a2accf5f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4e15bb976187ef8bad2a73bee67d901c4b33cd729ed1a70989a4836270506cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8756233c074b02053eed8aca4f65f393a15e242034961f12952e43145b4ff261"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures and musl
    os = OS.linux? ? "linux" : "darwin"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    node_modules = libexec/"lib/node_modules/tweakcc/node_modules"
    prebuilds = node_modules/"node-lief/prebuilds"
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
