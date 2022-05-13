require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.73.0.tgz"
  sha256 "00b4a46559ec952e898c65cb1fda06274acf0747e40b05512aeb733262bf2686"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0c9285ebe7e1df5c04a6251a5475e4c37982cf754749e4b6139eccdcf262a39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0c9285ebe7e1df5c04a6251a5475e4c37982cf754749e4b6139eccdcf262a39"
    sha256 cellar: :any_skip_relocation, monterey:       "a721b54ab7a333c76125783bfed8493e80f7df487d8bb61810d58e7e5c8cc7a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a721b54ab7a333c76125783bfed8493e80f7df487d8bb61810d58e7e5c8cc7a9"
    sha256 cellar: :any_skip_relocation, catalina:       "a721b54ab7a333c76125783bfed8493e80f7df487d8bb61810d58e7e5c8cc7a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8085988afa86ea30cc96b7c4bb5eb44dca072d258eb6e884c61d6982785574e"
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
