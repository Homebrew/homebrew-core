class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.22.1.tgz"
  sha256 "bb54e3ab92be975529ba9e619a7530461b384804c555dbd2b06d29427619ca1d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5b478d3982d337ee9567b79793b90be01a20a9417529e764ba2282f927c1341"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5b478d3982d337ee9567b79793b90be01a20a9417529e764ba2282f927c1341"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5b478d3982d337ee9567b79793b90be01a20a9417529e764ba2282f927c1341"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15fb11f8fa191f12db184487b55aa9cb0e23967e3623b181b7ebd159c7acac4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15fb11f8fa191f12db184487b55aa9cb0e23967e3623b181b7ebd159c7acac4a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
