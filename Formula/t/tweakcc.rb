class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-3.1.4.tgz"
  sha256 "f751a1f1eee62750136d445c6b1d7eccf86dc51e1da90392237e4bc9301b30df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ee850f079f003c7ad4e8c923f387d0ad1de565578f1c51a5a05cfc5ca88c830"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ee850f079f003c7ad4e8c923f387d0ad1de565578f1c51a5a05cfc5ca88c830"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ee850f079f003c7ad4e8c923f387d0ad1de565578f1c51a5a05cfc5ca88c830"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9b04cab35caf0e961b5b1f35e88d0298a527574778819603c29004b4b5ea79d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f17c3d9f52a440631f62e92752b2925754eaeb9e23862e74ff58bb5956137e31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bd6e51a6b1b9cda165efb4365e236795e1e7235ea7d642277c1cb6bc06115b9"
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
