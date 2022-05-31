require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.75.4.tgz"
  sha256 "d402117f703824e551e1269db77b00c2819c02755f7c9606f166634817639024"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d4f60f5cd8d03c15ddd5239c1d6224cfa6094dc0e887228b9be48cbbd60c68a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d4f60f5cd8d03c15ddd5239c1d6224cfa6094dc0e887228b9be48cbbd60c68a"
    sha256 cellar: :any_skip_relocation, monterey:       "873f1c351a1aaf744b491e502a96f185c71f21b98912ff494788183671be1d73"
    sha256 cellar: :any_skip_relocation, big_sur:        "873f1c351a1aaf744b491e502a96f185c71f21b98912ff494788183671be1d73"
    sha256 cellar: :any_skip_relocation, catalina:       "873f1c351a1aaf744b491e502a96f185c71f21b98912ff494788183671be1d73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eab4517dc2ba4127735a133c8beaac4b8fc3be9bedc4fc27548a6db09ac21d94"
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
