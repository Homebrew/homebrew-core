require "language/node"

class Sloc < Formula
  desc "Simple tool to count source lines of code"
  homepage "https://github.com/flosse/sloc"
  url "https://registry.npmjs.org/sloc/-/sloc-0.3.2.tgz"
  sha256 "25ac2a41e015a8ee0d0a890221d064ad0288be8ef742c4ec903c84a07e62b347"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "401c79fd025169082d6f2a07f7855dc67af62872f54bc7d22f0ec59aeef416fe"
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
