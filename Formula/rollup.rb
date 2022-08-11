require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.77.3.tgz"
  sha256 "384d550745ee5b9a1a9953f754570c4864c2a691c4d265bf5747e9168b33d7f2"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67071465af56d512e28944513cce6ef0bf9418517b72ddebd911885af6a35641"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67071465af56d512e28944513cce6ef0bf9418517b72ddebd911885af6a35641"
    sha256 cellar: :any_skip_relocation, monterey:       "41bb54425db331b17d74787cb77797d885f3ddf228556acb85a54e78670b616a"
    sha256 cellar: :any_skip_relocation, big_sur:        "41bb54425db331b17d74787cb77797d885f3ddf228556acb85a54e78670b616a"
    sha256 cellar: :any_skip_relocation, catalina:       "41bb54425db331b17d74787cb77797d885f3ddf228556acb85a54e78670b616a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a2bf1d5e98349e01da52704481da5af82fa32bdd9ab9463cff5038d844e1b13"
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
