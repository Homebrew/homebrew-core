require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.63.0.tgz"
  sha256 "e23b4eb0d0fddca66fc98554118be379d6807fe6d77f760fa1eacbb0b49c5f08"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be9856ee0b61bb17ddbddfb70ca9d69244c8e6f1223d0352304a6213fb597885"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be9856ee0b61bb17ddbddfb70ca9d69244c8e6f1223d0352304a6213fb597885"
    sha256 cellar: :any_skip_relocation, monterey:       "7e0800314feb78da9c87ead747b2ae71aa47050def28aa4e9acdc48c01927b31"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e0800314feb78da9c87ead747b2ae71aa47050def28aa4e9acdc48c01927b31"
    sha256 cellar: :any_skip_relocation, catalina:       "7e0800314feb78da9c87ead747b2ae71aa47050def28aa4e9acdc48c01927b31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a84e37ec628ca1836399136fe9dd5522b1f55586ae34f6fd64e46076ebbddc2f"
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
