require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.7.3.tgz"
  sha256 "c7f19c6b7d75d5356a5ca14aedf4068e15860858dbf022020b5bda643c8c876d"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2e01e27963dc68e60faca3bc9438f8f7e8f7d06eb4f4b2840b28e5a62e1118d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2e01e27963dc68e60faca3bc9438f8f7e8f7d06eb4f4b2840b28e5a62e1118d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2e01e27963dc68e60faca3bc9438f8f7e8f7d06eb4f4b2840b28e5a62e1118d"
    sha256 cellar: :any_skip_relocation, ventura:        "14fbb251dab94008e1cfd1350bf220847edab2efb46c077068f7a1dd33c92d8c"
    sha256 cellar: :any_skip_relocation, monterey:       "14fbb251dab94008e1cfd1350bf220847edab2efb46c077068f7a1dd33c92d8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "14fbb251dab94008e1cfd1350bf220847edab2efb46c077068f7a1dd33c92d8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5362c5b995d8a1f31ce2e7198caac10ff33f228da5ce30dd8377c43dcc554b5"
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
