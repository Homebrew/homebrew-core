require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.66.1.tgz"
  sha256 "36fa339fdc66f9d95bc419ccf1685250a3be305dd80c6fe3e1bf816eb47458d7"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce57321e1994dfd068571c9cb7a997177d626211434b8103deec2024dd1e8a5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce57321e1994dfd068571c9cb7a997177d626211434b8103deec2024dd1e8a5a"
    sha256 cellar: :any_skip_relocation, monterey:       "f43cf03156c8a35f9052d6aa7d5f396f105e7c8d1b28a18786d82dcad994dd53"
    sha256 cellar: :any_skip_relocation, big_sur:        "f43cf03156c8a35f9052d6aa7d5f396f105e7c8d1b28a18786d82dcad994dd53"
    sha256 cellar: :any_skip_relocation, catalina:       "f43cf03156c8a35f9052d6aa7d5f396f105e7c8d1b28a18786d82dcad994dd53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1a426fb79f50f0dcf35d432684252f124232c3b2ce1885c0bc7aa5218721efb"
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
