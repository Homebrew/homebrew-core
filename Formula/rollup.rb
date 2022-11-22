require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.4.0.tgz"
  sha256 "a1bcb219e0698d4667eb44134fed30271fca99f3ad3c9e152f0c32e5161b0379"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1184b755504865cb9f9f89636586a0a9e2fe6e15fb1b8d5b5b0ae937c1571e4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1184b755504865cb9f9f89636586a0a9e2fe6e15fb1b8d5b5b0ae937c1571e4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1184b755504865cb9f9f89636586a0a9e2fe6e15fb1b8d5b5b0ae937c1571e4b"
    sha256 cellar: :any_skip_relocation, ventura:        "230efaa49c4d0d975c3cc4b16150c788d16537e99ba21b3b4259e164f7a12a90"
    sha256 cellar: :any_skip_relocation, monterey:       "230efaa49c4d0d975c3cc4b16150c788d16537e99ba21b3b4259e164f7a12a90"
    sha256 cellar: :any_skip_relocation, big_sur:        "230efaa49c4d0d975c3cc4b16150c788d16537e99ba21b3b4259e164f7a12a90"
    sha256 cellar: :any_skip_relocation, catalina:       "230efaa49c4d0d975c3cc4b16150c788d16537e99ba21b3b4259e164f7a12a90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2ef7d25ab6d1399b63dc96596b8b38637e393c1ec6cca81681db9cf85e54942"
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
