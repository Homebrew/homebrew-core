require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.25.3.tgz"
  sha256 "9d3de8b2776600bc19bdde1ebd60096165635da1e386ff38ff5d753a14c661b8"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e977fc302d3384e6e5824dff81ca49f480db7131cebb74479be6ca74c50c2d9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e977fc302d3384e6e5824dff81ca49f480db7131cebb74479be6ca74c50c2d9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e977fc302d3384e6e5824dff81ca49f480db7131cebb74479be6ca74c50c2d9d"
    sha256 cellar: :any_skip_relocation, ventura:        "f937aeb55f783f88943aa2377ec37e689f8fd9a56d5f285c202e2f5b0a188b53"
    sha256 cellar: :any_skip_relocation, monterey:       "f937aeb55f783f88943aa2377ec37e689f8fd9a56d5f285c202e2f5b0a188b53"
    sha256 cellar: :any_skip_relocation, big_sur:        "f937aeb55f783f88943aa2377ec37e689f8fd9a56d5f285c202e2f5b0a188b53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5305bf88ba285be99a14b0d311424e0c9292f2eca04bb8dad606dd577e716a52"
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
