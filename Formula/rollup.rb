require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.71.1.tgz"
  sha256 "84800c02a4822216cff4435c8625d2453a91a09d8f780b3ec26591d7b0d27cfa"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f233a3ad26dc491f5812507dc640add01425cffaa126478647ff9a6bec9eeebe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f233a3ad26dc491f5812507dc640add01425cffaa126478647ff9a6bec9eeebe"
    sha256 cellar: :any_skip_relocation, monterey:       "6e21c823f28c0ef7d4dee7817dd0b8ad2042c3a1ad26976dbc7268e918848837"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e21c823f28c0ef7d4dee7817dd0b8ad2042c3a1ad26976dbc7268e918848837"
    sha256 cellar: :any_skip_relocation, catalina:       "6e21c823f28c0ef7d4dee7817dd0b8ad2042c3a1ad26976dbc7268e918848837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2140888c89cd429a0e0940215731abd635d4d27d8d771e05c878b9cf99ca8422"
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
