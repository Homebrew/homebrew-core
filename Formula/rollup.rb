require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.68.0.tgz"
  sha256 "1df95469d1d48515da6c5b842a4f3c0eaebdb5a08f5c59a3282abb7dca19ee08"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6b0b0765bbb366093ddb336ed16b55dfc19111bfae495971ed2395bd65388ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6b0b0765bbb366093ddb336ed16b55dfc19111bfae495971ed2395bd65388ce"
    sha256 cellar: :any_skip_relocation, monterey:       "1e4e85c61ed2d3deccbb343dd9c21d7ed9469144b9239b3e910aaecb8fff4227"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e4e85c61ed2d3deccbb343dd9c21d7ed9469144b9239b3e910aaecb8fff4227"
    sha256 cellar: :any_skip_relocation, catalina:       "1e4e85c61ed2d3deccbb343dd9c21d7ed9469144b9239b3e910aaecb8fff4227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "217c12d1f3cedf0f2d085ffd2e1b5ad859eb67f5db57631b89018efc1aebf5a8"
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
