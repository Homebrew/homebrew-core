require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.17.0.tgz"
  sha256 "b176b933350246ef4726de1cc4ed678a3e033bfcf1c59c07a1bc11b91c1d9a43"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "881a36c71a148cfea5ef083800550a9b5c615b5bc1893485208c7a842e21192e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "881a36c71a148cfea5ef083800550a9b5c615b5bc1893485208c7a842e21192e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "881a36c71a148cfea5ef083800550a9b5c615b5bc1893485208c7a842e21192e"
    sha256 cellar: :any_skip_relocation, ventura:        "871c95ada81f3f5199bd1ebfa42ae6a93e20f252d426532edd352dfd86946f88"
    sha256 cellar: :any_skip_relocation, monterey:       "871c95ada81f3f5199bd1ebfa42ae6a93e20f252d426532edd352dfd86946f88"
    sha256 cellar: :any_skip_relocation, big_sur:        "871c95ada81f3f5199bd1ebfa42ae6a93e20f252d426532edd352dfd86946f88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79e11196372a1f983c169eee91a748552e79916870a017f4be54513f535444cd"
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
