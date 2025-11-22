class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-3.1.1.tgz"
  sha256 "6b234ea2b03e22b02823a57d6a91fd78f6e78e5de916f76c78f4865e443c3175"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e1e087d392d3755688fdd6c5713c435af090104b0eb338375862c306a1cbbfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e1e087d392d3755688fdd6c5713c435af090104b0eb338375862c306a1cbbfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e1e087d392d3755688fdd6c5713c435af090104b0eb338375862c306a1cbbfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa9b131dd9b36c5d6219475e7d66fa356b3810ab02f39decfbcc641d89522763"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8396359e787d08531524a8c6eda4c073eedf60c12c1f0b64165daa2f2baa04bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f1d0e997802d8df1398ddb565040419c289b586902d806838d27c94bca6afeb"
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
