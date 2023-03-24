require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.20.2.tgz"
  sha256 "2f75e39b5953e34f935f7735f330d94b4dfb9e44298fea380e63797b6662cbfa"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "196b9cb6a435be6ea2ba3662b830e14b9b85d9c078bf7f1a927a24141a86c1cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "196b9cb6a435be6ea2ba3662b830e14b9b85d9c078bf7f1a927a24141a86c1cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "196b9cb6a435be6ea2ba3662b830e14b9b85d9c078bf7f1a927a24141a86c1cc"
    sha256 cellar: :any_skip_relocation, ventura:        "e046a7b6382a28ffd8e73c0a0521b6fc24f1b04f9132e2d8c80abb3eaf606721"
    sha256 cellar: :any_skip_relocation, monterey:       "e046a7b6382a28ffd8e73c0a0521b6fc24f1b04f9132e2d8c80abb3eaf606721"
    sha256 cellar: :any_skip_relocation, big_sur:        "e046a7b6382a28ffd8e73c0a0521b6fc24f1b04f9132e2d8c80abb3eaf606721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf6eb21aea417b8920f0ee30df773496b9694ffe8464dcda7e0c0b339c19c89c"
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
