class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.31.0.tgz"
  sha256 "015eab25fa9bf3ea74597e2dcf4093ad3369e5600caa4aeda648e9eaa4f99933"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f8e73f8bd4eca680d8d9ddcad1df623ec41d0cf1e3f9f0382855d262e0b491ff"
    sha256 cellar: :any,                 arm64_sonoma:  "f8e73f8bd4eca680d8d9ddcad1df623ec41d0cf1e3f9f0382855d262e0b491ff"
    sha256 cellar: :any,                 arm64_ventura: "f8e73f8bd4eca680d8d9ddcad1df623ec41d0cf1e3f9f0382855d262e0b491ff"
    sha256 cellar: :any,                 sonoma:        "15215913ca06097c6e959cdba1e49e1ed1f49288a7c40553bde0c0b1f86cb840"
    sha256 cellar: :any,                 ventura:       "15215913ca06097c6e959cdba1e49e1ed1f49288a7c40553bde0c0b1f86cb840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e228eef1d76bdee56865342e4f98dd7b6e3ea67e2b5b3bd515201b9a48f670aa"
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
