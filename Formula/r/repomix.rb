class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://repomix.com"
  url "https://registry.npmjs.org/repomix/-/repomix-1.19.0.tgz"
  sha256 "e5504ac6a3e1729b27b78efa8e7f15c468bda64c5aad533566666e3d95ccc064"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6eb74443768e6dd789611daa6bbc0413aef569b1fbe9e28aa44fd35e3f3437dc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repomix --version")

    (testpath/"test_repo").mkdir
    (testpath/"test_repo/test_file.txt").write("Test content")

    output = shell_output("#{bin}/repomix --style plain --compress #{testpath}/test_repo")
    assert_match "Packing completed successfully!", output
    assert_match "This file is a merged representation of the entire codebase", (testpath/"repomix-output.txt").read
  end
end
