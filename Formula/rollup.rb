require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.78.0.tgz"
  sha256 "c32667cea81c8c23fd32654e969704e0dc4602e2a13551ca2247bce76c545541"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faba05bc525c631a2da5d44d871dd9712f520753e4c7fa9c003bccfcf9a2ceef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "faba05bc525c631a2da5d44d871dd9712f520753e4c7fa9c003bccfcf9a2ceef"
    sha256 cellar: :any_skip_relocation, monterey:       "edd5f9ea563a8ce5f4699d773fdc89a02acd40655aed6f2c84351929b2319af2"
    sha256 cellar: :any_skip_relocation, big_sur:        "edd5f9ea563a8ce5f4699d773fdc89a02acd40655aed6f2c84351929b2319af2"
    sha256 cellar: :any_skip_relocation, catalina:       "edd5f9ea563a8ce5f4699d773fdc89a02acd40655aed6f2c84351929b2319af2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebdc72145968b6a7b496d67b04dafed7c7ea0bb40aba0405cebb3030ee2b89ea"
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
