class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-4.4.0.tgz"
  sha256 "125b94a0c97743f3374071c78a3fc22829c5ee9497a7740a5f652ba7629d8d9d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "73a0512717497d37f9e4047377bb103cbd10bbf7874961549b3625677708cc66"
    sha256 cellar: :any,                 arm64_tahoe:       "73a0512717497d37f9e4047377bb103cbd10bbf7874961549b3625677708cc66"
    sha256 cellar: :any,                 arm64_sequoia:     "73a0512717497d37f9e4047377bb103cbd10bbf7874961549b3625677708cc66"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "394d75d35dacac8c6dc3d0a52220ef61af9f3922dd517764de9cb48a03afca68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2d003892c057de3fe596abd3a3320098ab7571332a2ce36aefecb64c987ac0e9"
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
