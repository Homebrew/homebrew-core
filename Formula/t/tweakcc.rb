class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-3.4.0.tgz"
  sha256 "2da6ee2d9b0ee5c2c61ac11b830e8afb353952e4aa4f9e110922d7e83775d1fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbd2dc4c59b74c7adb099afcadd1aab1cece0df05de2d1a68ff169c9eff0e0cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbaff129de4c90e9fe734758afd7b144b4e21aa064946739d72848f35b4e1b97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbaff129de4c90e9fe734758afd7b144b4e21aa064946739d72848f35b4e1b97"
    sha256 cellar: :any_skip_relocation, sonoma:        "25f0ab0ae883d92d5b864d57b2e830e8c867cab715216a64d3bdeedd8b9001ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33d325b24643d8ad0b112e7ee2d5a3a9e8d9f839aff6136321d49ec5b7de7843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7cbb46ec37a6e33ffb3134282b0580c1bd08c0d9e33e321d89602ca6e601c56"
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
