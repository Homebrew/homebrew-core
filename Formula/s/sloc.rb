require "language/node"

class Sloc < Formula
  desc "Simple tool to count source lines of code"
  homepage "https://github.com/flosse/sloc#readme"
  url "https://registry.npmjs.org/sloc/-/sloc-0.3.1.tgz"
  sha256 "87c69906dbf8bca74612abf1bed2464257500e31a2dde9ae51f9ebc18bf7b4aa"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f2fffe38885f7cebab2d105c1dc8492bdfd9a7b8b02a7ae2cc03ad35f46066f5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    std_output = <<~EOS
      Path,Physical,Source,Comment,Single-line comment,Block comment,Mixed,Empty block comment,Empty,To Do
      Total,4,4,0,0,0,0,0,0,0
    EOS

    assert_match std_output, shell_output("#{bin}/sloc --format=csv .")
  end
end
