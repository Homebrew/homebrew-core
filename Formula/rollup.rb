require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.6.0.tgz"
  sha256 "e3663a443fe8bed64380ea6f41e7a1fa35f74f57a39da506917f1475e48954e8"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b2610242f3c77f4a0d33364663081f71863ccc17fa1f18a6927bb6033c15774"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b2610242f3c77f4a0d33364663081f71863ccc17fa1f18a6927bb6033c15774"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b2610242f3c77f4a0d33364663081f71863ccc17fa1f18a6927bb6033c15774"
    sha256 cellar: :any_skip_relocation, ventura:        "e846cd7d2e8ffe924b48470b2ad75508ea609a1533cc700ea23feda69f254eca"
    sha256 cellar: :any_skip_relocation, monterey:       "e846cd7d2e8ffe924b48470b2ad75508ea609a1533cc700ea23feda69f254eca"
    sha256 cellar: :any_skip_relocation, big_sur:        "e846cd7d2e8ffe924b48470b2ad75508ea609a1533cc700ea23feda69f254eca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3881011c5a6a0341b97d4242f58798fd772766f924bd0f9e6a8de3d40d02755"
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
