class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-4.0.14.tgz"
  sha256 "e0e10366075a304405fbc306d77015ea1fae27dd616de4c5e277f00f22c7408c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "631a6385a19f02c82d7882becdf10e485f4c850214a538848643be8c52c30d34"
    sha256 cellar: :any,                 arm64_sequoia: "1609428921b9014e741d29a04c2381bb245b271c99c781e43aaf7875fa02b280"
    sha256 cellar: :any,                 arm64_sonoma:  "1609428921b9014e741d29a04c2381bb245b271c99c781e43aaf7875fa02b280"
    sha256 cellar: :any,                 sonoma:        "f53dd0810e1e2429c994d0d6486dea2345650c185af028b65988119cfc6d7907"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3afd52425d413d737c41cc5ed9766aab87f5ac3673470749586e7c5bb13293a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9bbba6cae7951c03491dcd4b3f3d80710d2bc5e2c642d8fe2341a5ce53b03f5"
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
