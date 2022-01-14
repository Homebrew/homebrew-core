require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.64.0.tgz"
  sha256 "1b011f1f491645e86af2461053619ef2c9f405912ed4fff515470bfffde38d8f"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4df584baec9b70645aa3579e5ff42ace1592314f3ef3abab53d5c0f3568af48c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4df584baec9b70645aa3579e5ff42ace1592314f3ef3abab53d5c0f3568af48c"
    sha256 cellar: :any_skip_relocation, monterey:       "2f19915ddfefdcb22fa0f143f6b6a63496848ea72352f9781052ccd57e1a7ed0"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f19915ddfefdcb22fa0f143f6b6a63496848ea72352f9781052ccd57e1a7ed0"
    sha256 cellar: :any_skip_relocation, catalina:       "2f19915ddfefdcb22fa0f143f6b6a63496848ea72352f9781052ccd57e1a7ed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79991b221c7086029845fda0ea5f95b47f9b7118b9055540e9c593175887888b"
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
