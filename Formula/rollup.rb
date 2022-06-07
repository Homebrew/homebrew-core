require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.75.6.tgz"
  sha256 "69a1670e2702f72781aceec1924d4f3d3eee2610de01a6376f17c93b7ad24bae"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b59a7f4a05df2aeb5a024d0896b6671add3539cc2a6d1954929a8f2c9b00216"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b59a7f4a05df2aeb5a024d0896b6671add3539cc2a6d1954929a8f2c9b00216"
    sha256 cellar: :any_skip_relocation, monterey:       "a3ab1c9dd6e5714b5bfe9405856d508cac92ce2b528d5986da6ee5551192d0ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3ab1c9dd6e5714b5bfe9405856d508cac92ce2b528d5986da6ee5551192d0ce"
    sha256 cellar: :any_skip_relocation, catalina:       "a3ab1c9dd6e5714b5bfe9405856d508cac92ce2b528d5986da6ee5551192d0ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c2f040318d9c5b3fed79a629396335c0e1ad3f3c4d131ed744f45804496c882"
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
