class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.22.1.tgz"
  sha256 "93c7018d30af36399f2ad886f046adc63f0f64c6865d9117d2599ccb5ab49226"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "071278a154825368befd7d5438345f822599d418960f12735108499097f8d5a6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "071278a154825368befd7d5438345f822599d418960f12735108499097f8d5a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "071278a154825368befd7d5438345f822599d418960f12735108499097f8d5a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "19d61949b1d882890353298b60150377382c2fbaa56d480c9d18e9e68a7578b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "19d61949b1d882890353298b60150377382c2fbaa56d480c9d18e9e68a7578b1"
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
