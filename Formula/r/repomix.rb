class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://repomix.com"
  url "https://registry.npmjs.org/repomix/-/repomix-1.15.0.tgz"
  sha256 "85f3e864b66fddf989dd7aaed6d634ce4b43f1a1ffde83a5051cfafdf1b8a7bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9d0d2c2b24f3bf7a050893be5cfbc6957915f723969064e26fef5c07010ab2f2"
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
