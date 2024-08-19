class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.21.0.tgz"
  sha256 "9db5866cdce51d334efb9655c7aa6d8ab6be2463860063f629e0a207e04c3387"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4c6350b9867cd7e809f9f2d8164f575a07284095f780596230ffae1a3006e1d1"
    sha256 cellar: :any,                 arm64_ventura:  "4c6350b9867cd7e809f9f2d8164f575a07284095f780596230ffae1a3006e1d1"
    sha256 cellar: :any,                 arm64_monterey: "4c6350b9867cd7e809f9f2d8164f575a07284095f780596230ffae1a3006e1d1"
    sha256 cellar: :any,                 sonoma:         "dea29744373e6c9f9d754d3590bbf109f444f686f9200b4ebbd6ed986e557de3"
    sha256 cellar: :any,                 ventura:        "dea29744373e6c9f9d754d3590bbf109f444f686f9200b4ebbd6ed986e557de3"
    sha256 cellar: :any,                 monterey:       "dea29744373e6c9f9d754d3590bbf109f444f686f9200b4ebbd6ed986e557de3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "779ff341fa13dd0d61acdd107fb0bf51291ce6223a7c31617bf7e2aeef7f246d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
