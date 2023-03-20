require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.20.0.tgz"
  sha256 "04f13bc9846bda6d6a99db8aa9d5ddc5373ed0f0cf5d0cb44d1f39e2df9e2a96"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbcaac0ad2f1b87b433b192d4847c02044b4895c6ab78012b6e26ce33986599f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbcaac0ad2f1b87b433b192d4847c02044b4895c6ab78012b6e26ce33986599f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbcaac0ad2f1b87b433b192d4847c02044b4895c6ab78012b6e26ce33986599f"
    sha256 cellar: :any_skip_relocation, ventura:        "44676f2bd08d64b22f174d1933716cf48ecac3cdd29fbfe9a4e00a4dbd42ea9d"
    sha256 cellar: :any_skip_relocation, monterey:       "44676f2bd08d64b22f174d1933716cf48ecac3cdd29fbfe9a4e00a4dbd42ea9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "44676f2bd08d64b22f174d1933716cf48ecac3cdd29fbfe9a4e00a4dbd42ea9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdf04421751ac0e1941ba78cf64e47af81cb7d424b2ecdfa4ca3b2de82c94756"
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
