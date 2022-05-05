require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.72.0.tgz"
  sha256 "1a9407bd6511bf00df669798cd05957ebee6da59b7bce51c66113edfdfaab568"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0db8703b46dffed759ab31def950e965b83cf2ec16e4408b220edd054b762de3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0db8703b46dffed759ab31def950e965b83cf2ec16e4408b220edd054b762de3"
    sha256 cellar: :any_skip_relocation, monterey:       "c2b9724962826be09e4060ba1a406db17f98f889318a5c52f1dccc173c184b04"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2b9724962826be09e4060ba1a406db17f98f889318a5c52f1dccc173c184b04"
    sha256 cellar: :any_skip_relocation, catalina:       "c2b9724962826be09e4060ba1a406db17f98f889318a5c52f1dccc173c184b04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b87b927c2b5b5bcda4d087345385671bfbc9a65d4004f0a3c3babccebb44fbd1"
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
