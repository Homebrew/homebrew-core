require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.77.0.tgz"
  sha256 "d68415cf62f45c0f6231213c309567ad407005b63b70697adbecb693dc7bce33"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcd840683bbf797f213ef825465afb4250596ee3d7dc5884ca8a38e87fbf7919"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcd840683bbf797f213ef825465afb4250596ee3d7dc5884ca8a38e87fbf7919"
    sha256 cellar: :any_skip_relocation, monterey:       "c6d24302e8a84d8a4e82004c58c66e4204d29a3fdfff2f69a77c8d4937e06e10"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6d24302e8a84d8a4e82004c58c66e4204d29a3fdfff2f69a77c8d4937e06e10"
    sha256 cellar: :any_skip_relocation, catalina:       "c6d24302e8a84d8a4e82004c58c66e4204d29a3fdfff2f69a77c8d4937e06e10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9f80dc1066d059d5cbf9406c319ff9879e711a1e6865eb25efd00d92020523e"
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
