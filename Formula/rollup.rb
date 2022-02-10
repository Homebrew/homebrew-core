require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.67.2.tgz"
  sha256 "a64594bbb732aad8a0cd38807d9bdc6a4585c0c2645c7e039919495852ee4e18"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3a9e0f4ff2204e41f64344a776e1383309e184f034c711a27be08d5354c4d79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3a9e0f4ff2204e41f64344a776e1383309e184f034c711a27be08d5354c4d79"
    sha256 cellar: :any_skip_relocation, monterey:       "7d9c2f1646ed085f2084cd5acd959bc841603809e023f9fcd515d92ea2a3b645"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d9c2f1646ed085f2084cd5acd959bc841603809e023f9fcd515d92ea2a3b645"
    sha256 cellar: :any_skip_relocation, catalina:       "7d9c2f1646ed085f2084cd5acd959bc841603809e023f9fcd515d92ea2a3b645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abff8758fea6ab27b73c82599377afd7ba7c93fa0f60b04ed5f45c5440886079"
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
