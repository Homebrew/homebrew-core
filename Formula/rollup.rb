require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.2.2.tgz"
  sha256 "8b973328c69ff25181a815f885c5294fd1417fb230f577debea0571bcdf5d9dd"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "780b83f1a44470c12f69e526209ca86b7461eea2b072835cd4fb9e5ea5903060"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "780b83f1a44470c12f69e526209ca86b7461eea2b072835cd4fb9e5ea5903060"
    sha256 cellar: :any_skip_relocation, monterey:       "773bd66e206f51b4eb668018b3e08731c22a56a1a6b6d90ce274ced59d8d36dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "773bd66e206f51b4eb668018b3e08731c22a56a1a6b6d90ce274ced59d8d36dc"
    sha256 cellar: :any_skip_relocation, catalina:       "773bd66e206f51b4eb668018b3e08731c22a56a1a6b6d90ce274ced59d8d36dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a78ead503dc2815d0f649b776215d55ea7095f04d8e451d9f8721b2e2ff8d547"
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
