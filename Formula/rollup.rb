require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.19.1.tgz"
  sha256 "5b522223d05dabf032381d59d159a111d612023d60bfba27beecb42c3a8732a5"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a69abf89299c74238178d23af6f04f8af4243c4554b9e710232a697610ba0366"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a69abf89299c74238178d23af6f04f8af4243c4554b9e710232a697610ba0366"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a69abf89299c74238178d23af6f04f8af4243c4554b9e710232a697610ba0366"
    sha256 cellar: :any_skip_relocation, ventura:        "c1bdcbc02be1ca7bf4522974830e3f258c566502d6e0768ab66c42fa7d087aad"
    sha256 cellar: :any_skip_relocation, monterey:       "c1bdcbc02be1ca7bf4522974830e3f258c566502d6e0768ab66c42fa7d087aad"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1bdcbc02be1ca7bf4522974830e3f258c566502d6e0768ab66c42fa7d087aad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d83b55384814c83924ffa555fed49bd7adddae8281e76a2bb510cf66b427bc80"
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
