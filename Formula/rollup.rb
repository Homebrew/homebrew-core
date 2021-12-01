require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.60.2.tgz"
  sha256 "293e59c82aeba3a4b7858e0441903b49858aace534c2e1ff8af7361c82b9f439"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e38842c4014dfdecaf8b96c8804689c939c27f117b162cf913015143df8bcc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e38842c4014dfdecaf8b96c8804689c939c27f117b162cf913015143df8bcc0"
    sha256 cellar: :any_skip_relocation, monterey:       "18a5a20953d80f0247930186c24d5e9ff52ab1a1e448f84731a14ac547239cf6"
    sha256 cellar: :any_skip_relocation, big_sur:        "18a5a20953d80f0247930186c24d5e9ff52ab1a1e448f84731a14ac547239cf6"
    sha256 cellar: :any_skip_relocation, catalina:       "18a5a20953d80f0247930186c24d5e9ff52ab1a1e448f84731a14ac547239cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "453ebf531cf4beeb7f4ce4f316bff97f9957df5a65994fdff6b44749c12566db"
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
