class Repopack < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repopack"
  url "https://github.com/yamadashy/repopack/archive/refs/tags/v0.1.44.tar.gz"
  sha256 "5fc913dcf0ece8f0c60ac1cbebd2871a5559b67e24af4238c2a191689fef84b5"
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
