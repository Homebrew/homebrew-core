require "language/node"

class Sloc < Formula
  desc "Simple tool to count source lines of code"
  homepage "https://github.com/flosse/sloc#readme"
  url "https://registry.npmjs.org/sloc/-/sloc-0.2.1.tgz"
  sha256 "fb56f1763b7dadfd0566f819665efc0725ba8dfbec13c75da3839edf309596e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "f241a7bf03cb7bb97bb061f5f46442d7a40de893697a5335c821049d471e9466" => :mojave
    sha256 "345308d671b83edb390c143554c64958135cf37bc7cd365ce613011da682a8b7" => :high_sierra
    sha256 "1386a024efebe74829d85c8d75d07ae9f09f8c8a8104aa41424a5ea8c425fca5" => :sierra
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
