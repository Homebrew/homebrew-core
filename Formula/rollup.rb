require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.60.0.tgz"
  sha256 "033376d305c55a5440e7dd1e1f636e2488e718bbd37d7911854c9cbd9fe21994"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "836bb1287737b43618d831b36294a3eeb77734ef8dd48c6d6b24b6416514790a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "836bb1287737b43618d831b36294a3eeb77734ef8dd48c6d6b24b6416514790a"
    sha256 cellar: :any_skip_relocation, monterey:       "5ffc7816a0908641f92c62ea279d4e3713f150a7d70f421875a96b2d6909d996"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ffc7816a0908641f92c62ea279d4e3713f150a7d70f421875a96b2d6909d996"
    sha256 cellar: :any_skip_relocation, catalina:       "5ffc7816a0908641f92c62ea279d4e3713f150a7d70f421875a96b2d6909d996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fafa6fd46b95c5bcce4c959ee83ea0222b941534d74f1cd720ff3b59d8dac05d"
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
