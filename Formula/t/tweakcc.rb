class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-4.0.11.tgz"
  sha256 "81d408b1158bfacd9e4bed24d3c34bababe74e9221339e1655cb5951e29fcb51"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3098213e27ec252b44f39452571a1a9a11b52921c20748ba510da1b8f8e554c9"
    sha256 cellar: :any,                 arm64_sequoia: "6203455b408b203e7491be0ba07e0ca1e83ec6e47e6c230ac845d457d484df17"
    sha256 cellar: :any,                 arm64_sonoma:  "6203455b408b203e7491be0ba07e0ca1e83ec6e47e6c230ac845d457d484df17"
    sha256 cellar: :any,                 sonoma:        "6b69333096876f591e7134f3969e5565c671c41013c972bcee97dffd37d8ade5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "002bf695f71a950f250cffe0fa8ff7b2ffd83f6aae4a3c313f5a7f8d1a75a69c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaa7f9069ce85480aba65f896f49f01a2994353ac7813d41f91cfb02e635b725"
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
