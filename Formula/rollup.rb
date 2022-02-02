require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.67.0.tgz"
  sha256 "87a44f7cc70dc001ae2095ca8eac37ab4f00e3474de1b9a763e455e14872c3f5"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1877db1f476f500953e8cc596a1c599a29e617acd635ae8f22686ad7643992a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1877db1f476f500953e8cc596a1c599a29e617acd635ae8f22686ad7643992a7"
    sha256 cellar: :any_skip_relocation, monterey:       "56be9ddfc495d9eb13b4a7123d42de0ac345e6d330c3e7789288dca749478474"
    sha256 cellar: :any_skip_relocation, big_sur:        "56be9ddfc495d9eb13b4a7123d42de0ac345e6d330c3e7789288dca749478474"
    sha256 cellar: :any_skip_relocation, catalina:       "56be9ddfc495d9eb13b4a7123d42de0ac345e6d330c3e7789288dca749478474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e73b6b325cb48a9936eda2fbad1dc70f8ade64051c11d6663454d0ee6024014"
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
