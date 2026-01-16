class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-3.2.5.tgz"
  sha256 "cc88c0a5a1c178bf13f9e389a824e08336a11ee98e049eece3bbc448d9cbd94a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01c4ae5bdab582ec7f3a25c9eeebc27ceb95ea5d415994e4caefb7b48d4dea92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88f2a03fe4c215871e57b3664d5ad68fbe050c9077d7bde8c5d0ec45467fc98b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88f2a03fe4c215871e57b3664d5ad68fbe050c9077d7bde8c5d0ec45467fc98b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7124aeab8abd70b1239a2a01ca9061e3065244a3af6a45568f7f619b88174958"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f4d07a44758c104d66c7584649816845947fab0caedd13d69a4c1546e2ea189"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9520f32f42b38bac59a71376053383188fba44c70007328843788aec249c8de"
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

    # Replace universal binaries with their native slices
    deuniversalize_machos node_modules/"app-path/main" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tweakcc --version")

    output = shell_output("#{bin}/tweakcc --apply 2>&1", 1)
    assert_match "Applying saved customizations to Claude Code", output
  end
end
