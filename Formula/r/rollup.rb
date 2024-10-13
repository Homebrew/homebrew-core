class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.24.0.tgz"
  sha256 "d38ec87eb99a1e460b118152ffdf5ed3117167f346fdfb9b476a12e43ea34a8a"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fa3ce4739918b37e36d909d724f1f9e45f64361e392d2e0631f79cae821a01ae"
    sha256 cellar: :any,                 arm64_sonoma:  "fa3ce4739918b37e36d909d724f1f9e45f64361e392d2e0631f79cae821a01ae"
    sha256 cellar: :any,                 arm64_ventura: "fa3ce4739918b37e36d909d724f1f9e45f64361e392d2e0631f79cae821a01ae"
    sha256 cellar: :any,                 sonoma:        "5825a23ab69809a4b8e1518243f107f6ea0b2339f2cf4503532eb4d4550447a0"
    sha256 cellar: :any,                 ventura:       "5825a23ab69809a4b8e1518243f107f6ea0b2339f2cf4503532eb4d4550447a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3571ab20728d25a4650821168091cc63e566cda2348d3f810df13c5cf81f336e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
