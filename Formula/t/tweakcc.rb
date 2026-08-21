class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-4.3.3.tgz"
  sha256 "b9134353f397921239f932bf7206ed433018f25ba4f90e58228881e246e6fd4d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a0b88fe8abd268b92ef1b3fd104c502a817c0f35d0e71455fe075febfe942b04"
    sha256 cellar: :any,                 arm64_sequoia: "a0b88fe8abd268b92ef1b3fd104c502a817c0f35d0e71455fe075febfe942b04"
    sha256 cellar: :any,                 arm64_sonoma:  "a0b88fe8abd268b92ef1b3fd104c502a817c0f35d0e71455fe075febfe942b04"
    sha256 cellar: :any,                 sonoma:        "256fba61c3ec56fa43811a548a5f3f5adbcb501060692108e245f7a457091277"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e77cda7f4b44233ef2da0cdf0930d11208a5a6673f832dd0fde01ed95abc92d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64d297458e5bd9ae883cb59fddc9dcf8bcae016c3f3bf037969c5ba1669018da"
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
