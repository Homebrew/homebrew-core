require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.67.1.tgz"
  sha256 "921e0d8b720cacbf84870975efd624ca30a2fc58a94453bb231519d65d4cd307"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a0fae9edbb9a0e590f9706b888c1fef2f8f7c36482fb894e2b65aeddca8539f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a0fae9edbb9a0e590f9706b888c1fef2f8f7c36482fb894e2b65aeddca8539f"
    sha256 cellar: :any_skip_relocation, monterey:       "2ccd0bce1fbe03c51a7065fd2a928cf28995150d4c8a1e8145bfefa15a6e7182"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ccd0bce1fbe03c51a7065fd2a928cf28995150d4c8a1e8145bfefa15a6e7182"
    sha256 cellar: :any_skip_relocation, catalina:       "2ccd0bce1fbe03c51a7065fd2a928cf28995150d4c8a1e8145bfefa15a6e7182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "632e0fe0e40c9ccc7588dc43d06a8ce1404c2db5a98c9f963eb9796de93fb784"
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
