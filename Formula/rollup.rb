require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.70.1.tgz"
  sha256 "60f7491cf2d28475aff1273297fd5c5dfdb55684abcfe4c43a43986321b7136c"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65704f6be0b18d1a2acea7ea8b65bdc6319b0c1431ed1dccb63068c673b69dc2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65704f6be0b18d1a2acea7ea8b65bdc6319b0c1431ed1dccb63068c673b69dc2"
    sha256 cellar: :any_skip_relocation, monterey:       "333b5934156a082bcbf5138ef1b24d817fa52d01181175ccaf21911acd641ce2"
    sha256 cellar: :any_skip_relocation, big_sur:        "333b5934156a082bcbf5138ef1b24d817fa52d01181175ccaf21911acd641ce2"
    sha256 cellar: :any_skip_relocation, catalina:       "333b5934156a082bcbf5138ef1b24d817fa52d01181175ccaf21911acd641ce2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd4e9411ed216a3683c836a5ee032c50c90ea2093a4ab4ca2b73facfac2b7471"
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
