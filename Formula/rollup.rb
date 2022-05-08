require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.72.1.tgz"
  sha256 "f4e17b45f23d5dd6f20071f81012b289779afd0b0b98eb60e32eefeed7aaba1f"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3145403398a856f8db40c1a51892e7d39165c4664db93549057a98950c6c74b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3145403398a856f8db40c1a51892e7d39165c4664db93549057a98950c6c74b9"
    sha256 cellar: :any_skip_relocation, monterey:       "d7e029627c78053b932e50ede86e6155375c0fb017391f24810548deb958d3a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7e029627c78053b932e50ede86e6155375c0fb017391f24810548deb958d3a1"
    sha256 cellar: :any_skip_relocation, catalina:       "d7e029627c78053b932e50ede86e6155375c0fb017391f24810548deb958d3a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc63b16f33c8269f7a64025d230b28e3652b48ce796d44744642fb2d0d59c913"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    deuniversalize_machos
  end

  test do
    (testpath/"test/main.js").write <<~EOS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    EOS

    (testpath/"test/foo.js").write <<~EOS
      export default 'hello world!';
    EOS

    expected = <<~EOS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    EOS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end
