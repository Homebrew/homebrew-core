class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.23.1.tgz"
  sha256 "77b90293fed975ed3435d5a0ba9fa93663739703a446df465af6a22d9d1e18b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c30fe2c1f0faea8b9ed54478f057effe93d4da343be0222970dd0b06b877ec53"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c30fe2c1f0faea8b9ed54478f057effe93d4da343be0222970dd0b06b877ec53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c30fe2c1f0faea8b9ed54478f057effe93d4da343be0222970dd0b06b877ec53"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "aa83842a0865fe96501268856382694e233614c89a4d50ff338b12b5186afe9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "aa83842a0865fe96501268856382694e233614c89a4d50ff338b12b5186afe9c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shadcn --version")

    pipe_output = pipe_output("#{bin}/shadcn init -d 2>&1", "brew\n")
    assert_match "Project initialization completed.", pipe_output
    assert_path_exists "#{testpath}/brew/components.json"
  end
end
