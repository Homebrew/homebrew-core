require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.14.3.tgz"
  sha256 "d2008a54f11fb91928e47ea43bf413aae0c505bff882555fd3cf5ca5cb02b678"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0de093486848e7799a28ea1459d25130bf50d73b16726176a394bc0f16927406"
    sha256 cellar: :any,                 arm64_ventura:  "0de093486848e7799a28ea1459d25130bf50d73b16726176a394bc0f16927406"
    sha256 cellar: :any,                 arm64_monterey: "0de093486848e7799a28ea1459d25130bf50d73b16726176a394bc0f16927406"
    sha256 cellar: :any,                 sonoma:         "e1e1da7d34937f02e5783d1e9e29ec98ece16fbf1962e9d2fcafa0628b1c69f6"
    sha256 cellar: :any,                 ventura:        "e1e1da7d34937f02e5783d1e9e29ec98ece16fbf1962e9d2fcafa0628b1c69f6"
    sha256 cellar: :any,                 monterey:       "e1e1da7d34937f02e5783d1e9e29ec98ece16fbf1962e9d2fcafa0628b1c69f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b74d2398d417f3e18ab790bbda8e751eb8ceb5ad2a613c4380832572c9dd6f31"
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
