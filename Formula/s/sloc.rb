class Sloc < Formula
  desc "Simple tool to count source lines of code"
  homepage "https://github.com/flosse/sloc"
  url "https://registry.npmjs.org/sloc/-/sloc-0.3.2.tgz"
  sha256 "25ac2a41e015a8ee0d0a890221d064ad0288be8ef742c4ec903c84a07e62b347"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da504ac5fe1db696740216c4ad46508bec57b12b240e3b242b21aa348ecfb890"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da504ac5fe1db696740216c4ad46508bec57b12b240e3b242b21aa348ecfb890"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da504ac5fe1db696740216c4ad46508bec57b12b240e3b242b21aa348ecfb890"
    sha256 cellar: :any_skip_relocation, sonoma:         "da504ac5fe1db696740216c4ad46508bec57b12b240e3b242b21aa348ecfb890"
    sha256 cellar: :any_skip_relocation, ventura:        "da504ac5fe1db696740216c4ad46508bec57b12b240e3b242b21aa348ecfb890"
    sha256 cellar: :any_skip_relocation, monterey:       "da504ac5fe1db696740216c4ad46508bec57b12b240e3b242b21aa348ecfb890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67f3b6498f7ffaeec6b245a9d4fd2bd562e95637afa78e570d64aa313b651236"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
