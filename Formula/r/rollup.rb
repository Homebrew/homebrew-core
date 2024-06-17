require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.18.0.tgz"
  sha256 "d5e69dd96023673d956b6a0f41c9eb6e8fa7d065f49dd50269f14e1a4b30fb9a"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "395dd1d81f429cb5b45b985c8bff91788e36dc966655abc641f2094cedc2778c"
    sha256 cellar: :any,                 arm64_ventura:  "e2e36c45c15566c855d8fa2b05da3dcdba0a379df81182f0444f8f99f3a35297"
    sha256 cellar: :any,                 arm64_monterey: "fda5e5b06c3e878cc790675028547b0efcce8b9502eaec39fdc215adb8ad6bf7"
    sha256 cellar: :any,                 sonoma:         "3051b041a31e8b58a1e9ee77ff84b337b3f623e27c7640d1f18e72f95997fe67"
    sha256 cellar: :any,                 ventura:        "97bf46ac136407878b591f45e56bfa133d7c102ce64b25f740c61c26906e7f33"
    sha256 cellar: :any,                 monterey:       "79fcafa41138e1a87a77cfc4b31f13273f21b3e2b53e378724d85d963f54582b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffc2428deb2b722b010ff4cfda906a62ee411bda8e7c2eddcd60bf9964bcb8d6"
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
