class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-4.0.13.tgz"
  sha256 "7033009e795103a20c61d7d9f6a065de4d5e605b64a9f1863f92f020b07037bc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f1d3a2ea755a332464debfa5eb7220287c07885c2eed21ee197f75c6ad658d8c"
    sha256 cellar: :any,                 arm64_sequoia: "1f15d5d544ddc5dba3bed74341181630cd679fa691bea6a21d6a4576d42a5926"
    sha256 cellar: :any,                 arm64_sonoma:  "1f15d5d544ddc5dba3bed74341181630cd679fa691bea6a21d6a4576d42a5926"
    sha256 cellar: :any,                 sonoma:        "8afe3a1ad8b070f23cf7ea3daecf8e2761f6a3b6c2964104f8688087e19add4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dff636b956edec88fdcd35aa6a579a82322dcf9e1381bd88304769edccffb464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b30b1ff1c28ef056cef3ab5d9ba43b2f6a626785e727a534691049be2211951"
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
