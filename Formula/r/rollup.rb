require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.13.1.tgz"
  sha256 "6aa98338826bd131b74c1eb004dbb80db61fcc069afce0bfe75972380750c5d9"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1d5644d158ee21baf3a64a93aa75520b161e13a7595376ba2a6814ea26b23781"
    sha256 cellar: :any,                 arm64_ventura:  "1d5644d158ee21baf3a64a93aa75520b161e13a7595376ba2a6814ea26b23781"
    sha256 cellar: :any,                 arm64_monterey: "1d5644d158ee21baf3a64a93aa75520b161e13a7595376ba2a6814ea26b23781"
    sha256 cellar: :any,                 sonoma:         "e28facdc3f50902c9eee73042e29ce9f70ad8847cda345ab6b1042309a62fcdb"
    sha256 cellar: :any,                 ventura:        "e28facdc3f50902c9eee73042e29ce9f70ad8847cda345ab6b1042309a62fcdb"
    sha256 cellar: :any,                 monterey:       "e28facdc3f50902c9eee73042e29ce9f70ad8847cda345ab6b1042309a62fcdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0f5b5bb4e3eba008e893320b8321c53d0a0891c92644c0ee33dd08c734301c1"
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
