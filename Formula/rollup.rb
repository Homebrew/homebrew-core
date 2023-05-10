require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.21.6.tgz"
  sha256 "af861d58b1acc636427199f0ac343d3f8c091f58119a3f13328995e5fb823859"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8473ec931d5fe3350135b68f84eef9faa1cc7a37305d571d7b1c000bd073d52a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8473ec931d5fe3350135b68f84eef9faa1cc7a37305d571d7b1c000bd073d52a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8473ec931d5fe3350135b68f84eef9faa1cc7a37305d571d7b1c000bd073d52a"
    sha256 cellar: :any_skip_relocation, ventura:        "c628fb3a3f25c32a6dcc793f19b638973fdd2757d51425793ea4f71077295f52"
    sha256 cellar: :any_skip_relocation, monterey:       "c628fb3a3f25c32a6dcc793f19b638973fdd2757d51425793ea4f71077295f52"
    sha256 cellar: :any_skip_relocation, big_sur:        "c628fb3a3f25c32a6dcc793f19b638973fdd2757d51425793ea4f71077295f52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79e9b4fc602dc056dc79a84479e43c56a4d4c17060795ac2035707721f078a3e"
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
