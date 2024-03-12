require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.13.0.tgz"
  sha256 "36725834e9e38f0b2974adca080c005aa95ade9da163e00ef6c1a0ec38b5309e"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6972ccceef0612a8650b360605c35035a0216759502a2047c9e2abed2ba797d7"
    sha256 cellar: :any,                 arm64_ventura:  "6972ccceef0612a8650b360605c35035a0216759502a2047c9e2abed2ba797d7"
    sha256 cellar: :any,                 arm64_monterey: "6972ccceef0612a8650b360605c35035a0216759502a2047c9e2abed2ba797d7"
    sha256 cellar: :any,                 sonoma:         "2709e29e33b141d8b01f0cf367b512215d5f437f7c1d3a27641065f622696932"
    sha256 cellar: :any,                 ventura:        "2709e29e33b141d8b01f0cf367b512215d5f437f7c1d3a27641065f622696932"
    sha256 cellar: :any,                 monterey:       "2709e29e33b141d8b01f0cf367b512215d5f437f7c1d3a27641065f622696932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6f6091c977ec5d3302e3de3dac66427cece0ed2897addb320f0b173dc75953f"
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
