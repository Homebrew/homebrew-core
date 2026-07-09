class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-4.3.0.tgz"
  sha256 "44837ea0643312446c21432c686800f27008f7e38efb48a2f7785f634da63952"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "af6e473924a757fda2ad46cd5d0eb4af45c8c9eeca44b4e75fcd531b860e88ef"
    sha256 cellar: :any,                 arm64_sequoia: "c29ff0f6caa392db5756405db9c350c8ccce4449fa41b03626b86490058fcad9"
    sha256 cellar: :any,                 arm64_sonoma:  "c29ff0f6caa392db5756405db9c350c8ccce4449fa41b03626b86490058fcad9"
    sha256 cellar: :any,                 sonoma:        "3ea47b3aa63eb2550c383b996238e8e0886772e08831d87f563c18caef0d56f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "419cb15d2d6da8973232b841a633463a9da997de9dd5c71d812333c2a53e83f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adf6541bd7432b1c927c2bbc9aa214b311ab5a9ad5f4be6685753d0ffc2853d7"
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
