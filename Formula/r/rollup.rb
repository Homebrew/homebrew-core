class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.53.0.tgz"
  sha256 "b61e3825e385cea466113e8765c97cef7b261cb51e81456a411e761036eb7877"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "70fcd470396f0853df5a545cec1d01a452ff9dbe456ff2b3e1fb6d6a50dfd703"
    sha256 cellar: :any,                 arm64_sequoia: "5b697dda7b703de6e33e70007ed3a88e1e90fe5e72ba1c28a8b266811229e842"
    sha256 cellar: :any,                 arm64_sonoma:  "5b697dda7b703de6e33e70007ed3a88e1e90fe5e72ba1c28a8b266811229e842"
    sha256 cellar: :any,                 sonoma:        "879ba11e4cae1bb396e5c478426bde542c28f3bab3d292362e1adeded9f483ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa3b597e4bd6c83c4b8dbbc8a1dcf2c7b85d9304ce9a466fcc5391a8e0a3b42f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c227a8513798fb8bb73644323fb66d775145f17f581b0730b7bd096be7fecf2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test/main.js").write <<~JS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    JS

    (testpath/"test/foo.js").write <<~JS
      export default 'hello world!';
    JS

    expected = <<~JS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    JS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end
