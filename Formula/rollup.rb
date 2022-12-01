require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.5.1.tgz"
  sha256 "7a30c32ce3cc24405ada12787fe93f179d8921c8c29093c8e5c21217b2d66b62"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0aca3fffcd7bc45a7edf66096befc7db9537fa16e5cdcb7b5bc6ea6f90add774"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0aca3fffcd7bc45a7edf66096befc7db9537fa16e5cdcb7b5bc6ea6f90add774"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0aca3fffcd7bc45a7edf66096befc7db9537fa16e5cdcb7b5bc6ea6f90add774"
    sha256 cellar: :any_skip_relocation, ventura:        "668d021c872af74fde94fdcf76f3e38e0bfb77839c989a256572f1fe5fc3079d"
    sha256 cellar: :any_skip_relocation, monterey:       "668d021c872af74fde94fdcf76f3e38e0bfb77839c989a256572f1fe5fc3079d"
    sha256 cellar: :any_skip_relocation, big_sur:        "668d021c872af74fde94fdcf76f3e38e0bfb77839c989a256572f1fe5fc3079d"
    sha256 cellar: :any_skip_relocation, catalina:       "668d021c872af74fde94fdcf76f3e38e0bfb77839c989a256572f1fe5fc3079d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f194850f807e29476a0fc1482cb37b100c39178f8b2c14ec1f7344c9f7a0b044"
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
