require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.61.0.tgz"
  sha256 "db65e9e7ca59534b61cea2ce66ba9377e2701238e46709eaea986146a39ede80"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "960e8c40e95649091b7ba2acea63eced99bbe2c9144567eff748b03646f18e5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "960e8c40e95649091b7ba2acea63eced99bbe2c9144567eff748b03646f18e5e"
    sha256 cellar: :any_skip_relocation, monterey:       "eaddfcaf69a58222154b7369607db38a9d28cba970c8b09bb72a5bbd28a09477"
    sha256 cellar: :any_skip_relocation, big_sur:        "eaddfcaf69a58222154b7369607db38a9d28cba970c8b09bb72a5bbd28a09477"
    sha256 cellar: :any_skip_relocation, catalina:       "eaddfcaf69a58222154b7369607db38a9d28cba970c8b09bb72a5bbd28a09477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14b4cd3b3f1aeade5c53d21f27249243e5602560029cd60f75e596b8ee388798"
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
