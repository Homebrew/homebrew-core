require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.20.0.tgz"
  sha256 "04f13bc9846bda6d6a99db8aa9d5ddc5373ed0f0cf5d0cb44d1f39e2df9e2a96"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10123342a930970fd83f9c0cd5bf8b97f31f096ec18e3a780c1692cecfd9cd52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10123342a930970fd83f9c0cd5bf8b97f31f096ec18e3a780c1692cecfd9cd52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10123342a930970fd83f9c0cd5bf8b97f31f096ec18e3a780c1692cecfd9cd52"
    sha256 cellar: :any_skip_relocation, ventura:        "c40778e12265cdbefa20a114af49136c878d6dbcaabd563e36f08106acf0607d"
    sha256 cellar: :any_skip_relocation, monterey:       "c40778e12265cdbefa20a114af49136c878d6dbcaabd563e36f08106acf0607d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c40778e12265cdbefa20a114af49136c878d6dbcaabd563e36f08106acf0607d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "698f4830cc4b03b7f69e3bf86cf74cf1191ffb0369419916a7a6208e038b7515"
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
