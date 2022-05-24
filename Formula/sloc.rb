require "language/node"

class Sloc < Formula
  desc "Simple tool to count source lines of code"
  homepage "https://github.com/flosse/sloc#readme"
  url "https://registry.npmjs.org/sloc/-/sloc-0.2.1.tgz"
  sha256 "fb56f1763b7dadfd0566f819665efc0725ba8dfbec13c75da3839edf309596e6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ebd1c159ad1f9f263528431a12b45bea9bffb4e0bf28393da414e9ccb62f9942"
    sha256 cellar: :any_skip_relocation, big_sur:       "28fb222768fc7ca90e6a9fa29c97d5f79f11bd9a928024ae84aabe8dfb8f0ff9"
    sha256 cellar: :any_skip_relocation, catalina:      "91254bb1e206f528b6b7d7a9afbdeec8390cfc54ad13d0850cc202d6242e08d0"
    sha256 cellar: :any_skip_relocation, mojave:        "f241a7bf03cb7bb97bb061f5f46442d7a40de893697a5335c821049d471e9466"
    sha256 cellar: :any_skip_relocation, high_sierra:   "345308d671b83edb390c143554c64958135cf37bc7cd365ce613011da682a8b7"
    sha256 cellar: :any_skip_relocation, sierra:        "1386a024efebe74829d85c8d75d07ae9f09f8c8a8104aa41424a5ea8c425fca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48646678b61d6a776462692734af1f5048d0c31faf8e2c6118e452ab48b553d4"
    sha256 cellar: :any_skip_relocation, all:           "bf12e86a52f11e012ab47f6ce03f690ecaf0e80b2250271378fcc3ef645ed7b6"
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
