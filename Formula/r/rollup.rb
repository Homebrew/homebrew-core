require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.13.1.tgz"
  sha256 "6aa98338826bd131b74c1eb004dbb80db61fcc069afce0bfe75972380750c5d9"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "80fde2f79bee36f34ed09dc56a61a30703cc984818b5972a65a279d96426c049"
    sha256 cellar: :any,                 arm64_ventura:  "80fde2f79bee36f34ed09dc56a61a30703cc984818b5972a65a279d96426c049"
    sha256 cellar: :any,                 arm64_monterey: "80fde2f79bee36f34ed09dc56a61a30703cc984818b5972a65a279d96426c049"
    sha256 cellar: :any,                 sonoma:         "21f7e8e896cf44ab94cbc515d0e20f5cc20c3d52014b4d08a6ce6d302128ed1b"
    sha256 cellar: :any,                 ventura:        "21f7e8e896cf44ab94cbc515d0e20f5cc20c3d52014b4d08a6ce6d302128ed1b"
    sha256 cellar: :any,                 monterey:       "21f7e8e896cf44ab94cbc515d0e20f5cc20c3d52014b4d08a6ce6d302128ed1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64e3cf23dccd2cdf59d3a98bc09f4d0c7edcac937abf9ea5b17bcb45d0c1f727"
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
