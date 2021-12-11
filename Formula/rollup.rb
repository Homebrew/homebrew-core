require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.61.1.tgz"
  sha256 "933501aa0bf62ddb7676c21cc32a52f1a3465f89635b79b22ca0107d813ffaf7"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fa8a752dc45557e5f64490d9ed42454be82b2027b1543449a25a1ad3c69faf9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fa8a752dc45557e5f64490d9ed42454be82b2027b1543449a25a1ad3c69faf9"
    sha256 cellar: :any_skip_relocation, monterey:       "fe7efcab2e04ab0d5d37199ab529e0c51eac746d4089afc4a5b91dbd87ef25d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe7efcab2e04ab0d5d37199ab529e0c51eac746d4089afc4a5b91dbd87ef25d5"
    sha256 cellar: :any_skip_relocation, catalina:       "fe7efcab2e04ab0d5d37199ab529e0c51eac746d4089afc4a5b91dbd87ef25d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab7676a7037e2c16d4bd27d0cf9ac914b7bf307bb5a14eb6ef0583421ee24780"
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
