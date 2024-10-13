class Repopack < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repopack"
  url "https://registry.npmjs.org/repopack/-/repopack-0.1.41.tgz"
  sha256 "3071830212038e8043023c3b9c859699320e94d412a409523d7f904a0f6f3c2d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f41790f9f5025a31a14546393e74f3a36cb02c2bf427c7f81bc9bb3dc747ffce"
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
