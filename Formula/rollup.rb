require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.75.0.tgz"
  sha256 "b8471843b9c4bd7ee9abdb2060a51b363ca6bbecacb8abe1efdadafe95ca8d83"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ebd00dd786bdef1207e7458fa8e39cf6a3e038d1b6252b5d79c6c84eed02e5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ebd00dd786bdef1207e7458fa8e39cf6a3e038d1b6252b5d79c6c84eed02e5c"
    sha256 cellar: :any_skip_relocation, monterey:       "c8d11d15478410d260ddbfe8add11f60b35010db838a3b61122277231e63484b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8d11d15478410d260ddbfe8add11f60b35010db838a3b61122277231e63484b"
    sha256 cellar: :any_skip_relocation, catalina:       "c8d11d15478410d260ddbfe8add11f60b35010db838a3b61122277231e63484b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8694c61c84027b4dbd42e5912b81efa9533d0098442f6be781f7710ecb97a036"
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
