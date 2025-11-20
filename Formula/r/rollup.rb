class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.53.3.tgz"
  sha256 "47655fd29e58c4bae4acac4ba191549d3f771de3992832d326d1dcf4ca23e7b8"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "814434968b62e4d02a1e5ba38a46178e199598d0cf166797aafceabe28c8a852"
    sha256 cellar: :any,                 arm64_sequoia: "650a2a685006786e5b2505ec71debd3cf53a19a64f3dab6644bc4d0c5cacf1b6"
    sha256 cellar: :any,                 arm64_sonoma:  "650a2a685006786e5b2505ec71debd3cf53a19a64f3dab6644bc4d0c5cacf1b6"
    sha256 cellar: :any,                 sonoma:        "54b70d8d11b759ffdb8e80f0e51a6ba7f8f70f5e25f5409daca58edc432bd876"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "108ce6c4219e599b4ed7cc2a81867509a3956e57c7785d37a194a67e4010cb3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b58b8993ca5cb3c69265a98e6a1abc9bcd30c0b8be573519bead462f32da7ea"
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
