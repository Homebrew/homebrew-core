class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-4.1.1.tgz"
  sha256 "03a3645c3b5169108315654828a8e056b2394b4f322d1551127d10a62c8b68e5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0c964abf09d7dfe91878f51928fc9b0511b81336f2bc8c4763e38aa35e35f762"
    sha256 cellar: :any,                 arm64_sequoia: "96453b71dc1517122aaa546cd18813903675c66f19f5a5b901d72d58ca012ae6"
    sha256 cellar: :any,                 arm64_sonoma:  "96453b71dc1517122aaa546cd18813903675c66f19f5a5b901d72d58ca012ae6"
    sha256 cellar: :any,                 sonoma:        "2e8e0bdcf6657e8827fd604038af7e26fb392987f7b40a9918dd91337c99e4b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8200122f8c1a3025eeb60115a460deef9498d4fe18ef8aa85ec39a966b1c17ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0b8c0a765effb73dd3ae1cfb2beebe1cf98becb920b54a38138738f771ebe5e"
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
