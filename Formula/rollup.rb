require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.69.0.tgz"
  sha256 "b60b2d37e3a531dc19a261eb64c56d0cc85fe701a677db1f8ff52f68c44ab767"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a40dc2fded7a5e7c7200152c965f49b383672bb12790cd700bb0040c022887e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a40dc2fded7a5e7c7200152c965f49b383672bb12790cd700bb0040c022887e"
    sha256 cellar: :any_skip_relocation, monterey:       "5e65c9eed93dc4f22c8bd1b6197f3a77234e6e65d78ad45031d5c49c4ee23ffa"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e65c9eed93dc4f22c8bd1b6197f3a77234e6e65d78ad45031d5c49c4ee23ffa"
    sha256 cellar: :any_skip_relocation, catalina:       "5e65c9eed93dc4f22c8bd1b6197f3a77234e6e65d78ad45031d5c49c4ee23ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a4ae92e52d0119c00ec1ae57b924b32af413b79a24c7f886526e9872cbc59e7"
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
