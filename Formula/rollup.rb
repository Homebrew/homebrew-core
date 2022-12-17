require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.7.5.tgz"
  sha256 "cac1cdc2fcd4dd2ad1512e032bb76d6719526f340668ab682367c9f3bdf44250"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6578b869eacd4d2a1f8b062cc9d1246167b7d3bf5355e6a3bb3d90ee261d5de5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6578b869eacd4d2a1f8b062cc9d1246167b7d3bf5355e6a3bb3d90ee261d5de5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6578b869eacd4d2a1f8b062cc9d1246167b7d3bf5355e6a3bb3d90ee261d5de5"
    sha256 cellar: :any_skip_relocation, ventura:        "5de724b8e1a3aee6d57dc24b919ea292c52a48c00825179c5ab31be3bdd1b5f6"
    sha256 cellar: :any_skip_relocation, monterey:       "5de724b8e1a3aee6d57dc24b919ea292c52a48c00825179c5ab31be3bdd1b5f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5de724b8e1a3aee6d57dc24b919ea292c52a48c00825179c5ab31be3bdd1b5f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2852ee51720d5dd98c27e34949679bb4ecd7452a071c990241ef59a98acb83d9"
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
