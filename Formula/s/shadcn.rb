class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.14.1.tgz"
  sha256 "a264f1be8f1247c755e1186a0b3eba305fb581f04a4bfccf5077ea43a548256d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e864fb1a1223a928fd99f6f3baac846f91395a3284e242f65084c7de03b3916"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e864fb1a1223a928fd99f6f3baac846f91395a3284e242f65084c7de03b3916"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e864fb1a1223a928fd99f6f3baac846f91395a3284e242f65084c7de03b3916"
    sha256 cellar: :any_skip_relocation, sonoma:        "b36c866ade300845434b24ab2185c6cf403212cb4532f18a7ca394245f429dc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4eda7618ad64d3dbfbd9d09798ed7dab0f42881b0d77fbf705f533727d44f450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eda7618ad64d3dbfbd9d09798ed7dab0f42881b0d77fbf705f533727d44f450"
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
