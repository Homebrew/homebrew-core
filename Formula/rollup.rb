require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.58.0.tgz"
  sha256 "8377f0d2563e4660302b99435758328a363d9c4d9103398595cd720ca47f3dca"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4486f23020100747bfc9c09ce641a23fb508dd67a1ea6ccadea7968b70339587"
    sha256 cellar: :any_skip_relocation, big_sur:       "9e7de204a94c07e1f81bed9334c8299ad167d1704afffe21414d25426400a363"
    sha256 cellar: :any_skip_relocation, catalina:      "9e7de204a94c07e1f81bed9334c8299ad167d1704afffe21414d25426400a363"
    sha256 cellar: :any_skip_relocation, mojave:        "9e7de204a94c07e1f81bed9334c8299ad167d1704afffe21414d25426400a363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82056f7241c7bb9d2e4b5dbcbd8bc3afa25260b801a70490b6f4a8488fcdae36"
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
