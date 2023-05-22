require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.22.1.tgz"
  sha256 "3932cb82d0833b238a274e1c447ce8f9881900f48b61bd9cacd521e62454d3d5"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47c6834eb7f9f5e26f0c2f7a1c7cc2341e5611cb13071d5c4475bcda23969897"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47c6834eb7f9f5e26f0c2f7a1c7cc2341e5611cb13071d5c4475bcda23969897"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47c6834eb7f9f5e26f0c2f7a1c7cc2341e5611cb13071d5c4475bcda23969897"
    sha256 cellar: :any_skip_relocation, ventura:        "0c7276705c67458205147f31734ff1856f37c7cd9b28e1c4e625f4c7bf00a882"
    sha256 cellar: :any_skip_relocation, monterey:       "0c7276705c67458205147f31734ff1856f37c7cd9b28e1c4e625f4c7bf00a882"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c7276705c67458205147f31734ff1856f37c7cd9b28e1c4e625f4c7bf00a882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42b22ae5c64d53ae944da65b7ef9a382830df4435ed083831625fe9fd81e4d2b"
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
