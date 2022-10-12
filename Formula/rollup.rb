require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.1.0.tgz"
  sha256 "4d3bd8a2044f5cc238c18d0b4482fd8b659e4613102fd4861974a1545a2f92fa"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7657475f71ad07e7d805c1568fac7eac0424f4c258aa9d6e904072cb422cb331"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7657475f71ad07e7d805c1568fac7eac0424f4c258aa9d6e904072cb422cb331"
    sha256 cellar: :any_skip_relocation, monterey:       "13c7fd4006827d20fd3a047efc34eb223ce2246ed07c372344c9689d01cf272c"
    sha256 cellar: :any_skip_relocation, big_sur:        "13c7fd4006827d20fd3a047efc34eb223ce2246ed07c372344c9689d01cf272c"
    sha256 cellar: :any_skip_relocation, catalina:       "13c7fd4006827d20fd3a047efc34eb223ce2246ed07c372344c9689d01cf272c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2990d31536a279c8bfb6503f98284d595ee6e46541dc94cbd528297c3c3fb627"
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
