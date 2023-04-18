require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.20.5.tgz"
  sha256 "9abf305d730520f268ba167ac31082df9ff1b9e189c07739393ce26a4f200023"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cef2643492babaef7553ff895da59b634fbaddd54a6e0dfa3dba9cc257f3eaae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cef2643492babaef7553ff895da59b634fbaddd54a6e0dfa3dba9cc257f3eaae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cef2643492babaef7553ff895da59b634fbaddd54a6e0dfa3dba9cc257f3eaae"
    sha256 cellar: :any_skip_relocation, ventura:        "7708f9a015edd7848af6edf9b78a097d16976ed4a19bd9691d440c9e4b3743e5"
    sha256 cellar: :any_skip_relocation, monterey:       "7708f9a015edd7848af6edf9b78a097d16976ed4a19bd9691d440c9e4b3743e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "7708f9a015edd7848af6edf9b78a097d16976ed4a19bd9691d440c9e4b3743e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4939fa9dce941ee11b4c4ac60e95a9bf685996fd1f02a90a47d5d24f59f3bbe2"
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
