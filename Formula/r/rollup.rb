require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.28.1.tgz"
  sha256 "e5e9b7504594172da43015a1cc9b40a5c18230a93ca9180f3a433ae28785fbc1"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b56f066fe82d8f888a845cb46d708ebe6f10c4e1cb5d5a1710dc3142e1d00a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b56f066fe82d8f888a845cb46d708ebe6f10c4e1cb5d5a1710dc3142e1d00a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b56f066fe82d8f888a845cb46d708ebe6f10c4e1cb5d5a1710dc3142e1d00a0"
    sha256 cellar: :any_skip_relocation, ventura:        "aa4a79ee9fa4a909336c86b1b927d44e298eeebf46e9c473436c19335db429c7"
    sha256 cellar: :any_skip_relocation, monterey:       "aa4a79ee9fa4a909336c86b1b927d44e298eeebf46e9c473436c19335db429c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa4a79ee9fa4a909336c86b1b927d44e298eeebf46e9c473436c19335db429c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfe2e9a7285d8ad68f134b4040d635d75a42ddab373cb2f269c6d314b34a9547"
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
