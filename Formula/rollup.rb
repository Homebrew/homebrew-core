require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.62.0.tgz"
  sha256 "ca6bf8109dc075100a3a0959abd49c2e32037aff448be19ae2c18e8f55d5dcd7"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c81d8815f16e4286d485bff9c27cec3eb8aa0dacefe647ffab11b12a0c72ef8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c81d8815f16e4286d485bff9c27cec3eb8aa0dacefe647ffab11b12a0c72ef8"
    sha256 cellar: :any_skip_relocation, monterey:       "4a062f3c2d31671166cddb8ea6d53d532106be1b1dbcb82ab91869bd6e6a5aff"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a062f3c2d31671166cddb8ea6d53d532106be1b1dbcb82ab91869bd6e6a5aff"
    sha256 cellar: :any_skip_relocation, catalina:       "4a062f3c2d31671166cddb8ea6d53d532106be1b1dbcb82ab91869bd6e6a5aff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce56d93b33f3c589082de0b30b2e9aa5e0af575b9443ea3de598d42161a26865"
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
