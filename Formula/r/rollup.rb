class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.50.2.tgz"
  sha256 "489177b2c4733aed1247fff352923e5fdcb924ef3318731deb69f92b4462d21e"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "67016becf92990f37b9bedbf0590962e63bddb05aaf2b9f1678fba4356795a90"
    sha256 cellar: :any,                 arm64_sequoia: "5f7a8d6506ad03d395cc65ea640099152b6f86cc3592e2a264f8ae9750e8ef04"
    sha256 cellar: :any,                 arm64_sonoma:  "5f7a8d6506ad03d395cc65ea640099152b6f86cc3592e2a264f8ae9750e8ef04"
    sha256 cellar: :any,                 sonoma:        "c12252e0a30dfda31b3ebb07903c75eb0e66fda9f8e74588d29623a75abae268"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00bebade72dbd9dca500c1138ed70068518989a7673765e248f58db5aa1eec26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc18f2b68d09dbedbc08c54364968a82baa25084f0e8a6e5eb915219a82c3173"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test/main.js").write <<~JS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    JS

    (testpath/"test/foo.js").write <<~JS
      export default 'hello world!';
    JS

    expected = <<~JS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    JS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end
