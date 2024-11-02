class Repopack < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repopack"
  url "https://github.com/yamadashy/repomix/archive/refs/tags/v0.1.45.tar.gz"
  sha256 "1024f80e44052c559ebccb7635d0d1c4b0a665ae68de49173c75d03a751f09eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8b9b0a7b32ad546f01dbd57ab8531fc5e97bf46476f8eca612aa99183d5b081e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repopack --version")

    (testpath/"test_repo").mkdir
    (testpath/"test_repo/test_file.txt").write("Test content")

    output = shell_output("#{bin}/repopack #{testpath}/test_repo")
    assert_match "Packing completed successfully!", output
    assert_match <<~EOS, (testpath/"repopack-output.txt").read
      ================================================================
      Repository Structure
      ================================================================
      test_file.txt

      ================================================================
      Repository Files
      ================================================================

      ================
      File: test_file.txt
      ================
      Test content
    EOS
  end
end
