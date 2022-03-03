require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.69.0.tgz"
  sha256 "b60b2d37e3a531dc19a261eb64c56d0cc85fe701a677db1f8ff52f68c44ab767"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0effc9afa6c04f2755506ff8d4b23546f6bc5b75c7beb47a1e8969ec6970c4e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0effc9afa6c04f2755506ff8d4b23546f6bc5b75c7beb47a1e8969ec6970c4e6"
    sha256 cellar: :any_skip_relocation, monterey:       "08cf9681c1485384780f01bf59989e2de69ac30574568e5801872f5dbd734469"
    sha256 cellar: :any_skip_relocation, big_sur:        "08cf9681c1485384780f01bf59989e2de69ac30574568e5801872f5dbd734469"
    sha256 cellar: :any_skip_relocation, catalina:       "08cf9681c1485384780f01bf59989e2de69ac30574568e5801872f5dbd734469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4496c88b7a268390a24dcee92b13ae28af9e414d3c2db0eb8c0c9aa0a21c21f8"
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
