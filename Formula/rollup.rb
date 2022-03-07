require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.70.0.tgz"
  sha256 "7d0ef6d3ee7e0c8f342a514cc9bd113993701916b8fe48665178c9b1ca4b83f5"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd1b83c94ee0ac33053a40b7995b33575a7e999d6317722a07f2210d8caac969"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd1b83c94ee0ac33053a40b7995b33575a7e999d6317722a07f2210d8caac969"
    sha256 cellar: :any_skip_relocation, monterey:       "293e65e9936be2c425144cd314bd76899a9867d7bdb8bd0b127f31d01c6d80e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "293e65e9936be2c425144cd314bd76899a9867d7bdb8bd0b127f31d01c6d80e4"
    sha256 cellar: :any_skip_relocation, catalina:       "293e65e9936be2c425144cd314bd76899a9867d7bdb8bd0b127f31d01c6d80e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86701f0f7a60e7431844a77459a890bceb9ec88a4fad91cdcd30b6c525919ab0"
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
