require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.20.2.tgz"
  sha256 "2f75e39b5953e34f935f7735f330d94b4dfb9e44298fea380e63797b6662cbfa"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d49704aaee8253b85b0db4e2015e4c5a4095f0ef4f1d64125d89fc88534dac83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d49704aaee8253b85b0db4e2015e4c5a4095f0ef4f1d64125d89fc88534dac83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d49704aaee8253b85b0db4e2015e4c5a4095f0ef4f1d64125d89fc88534dac83"
    sha256 cellar: :any_skip_relocation, ventura:        "7628c66447f2d8c92e3913f310af4d011d16e3694571cd157426cebf016a9c46"
    sha256 cellar: :any_skip_relocation, monterey:       "7628c66447f2d8c92e3913f310af4d011d16e3694571cd157426cebf016a9c46"
    sha256 cellar: :any_skip_relocation, big_sur:        "7628c66447f2d8c92e3913f310af4d011d16e3694571cd157426cebf016a9c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d0e909ed39c5228294f23a93d0338a2ea91b131109b9d8d03ed9278c7c7e1ec"
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
