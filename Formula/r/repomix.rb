class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://repomix.com"
  url "https://registry.npmjs.org/repomix/-/repomix-1.16.0.tgz"
  sha256 "13de0c9b6d8b554f3dee78db48ca6e3954b3f6cf491b11b430294a9680b4ba75"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3d86e7d4bb5dd7b8fd62f17797077f24580eccf1bc0c7eae19d5efde580decd0"
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
