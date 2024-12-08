class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-0.2.5.tgz"
  sha256 "357ba019dc9c78d06dbf36174d9d240759f27111b6e34a504d5b1e554f3abfa1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4e98557fe499a1152cf9a9993c3043cd5c90812b8a7741a25d8927bb4cd7b206"
  end

  depends_on "node"

  on_linux do
    depends_on "libx11"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repomix --version")

    (testpath/"test_repo").mkdir
    (testpath/"test_repo/test_file.txt").write("Test content")

    output = shell_output("#{bin}/repomix #{testpath}/test_repo")
    assert_match "Packing completed successfully!", output
    assert_match <<~EOS, (testpath/"repomix-output.txt").read
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
