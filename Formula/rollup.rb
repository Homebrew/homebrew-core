require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.66.0.tgz"
  sha256 "c932aaec8151cecff007b8002dd05a2a3ed7ac39030e499ea15d4ee020e62ce9"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62ca73439fb9c5c356bc8ecce7eb6dac8afc41a2018a2cc4c4f1efa86e05d53e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62ca73439fb9c5c356bc8ecce7eb6dac8afc41a2018a2cc4c4f1efa86e05d53e"
    sha256 cellar: :any_skip_relocation, monterey:       "ae9c67ad9635e514f2bdf2b85b83abf034e3bcb8fb6e0d62a6bf52275c04d352"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae9c67ad9635e514f2bdf2b85b83abf034e3bcb8fb6e0d62a6bf52275c04d352"
    sha256 cellar: :any_skip_relocation, catalina:       "ae9c67ad9635e514f2bdf2b85b83abf034e3bcb8fb6e0d62a6bf52275c04d352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb8f806b44398a6e82453aa63c33ee23f5c458f8e46201d968629effd9a9e48e"
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
