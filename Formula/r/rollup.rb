class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.35.0.tgz"
  sha256 "cb9772a455244066a9c3dd1dcfab9797b4197898dabf3c2f9e65d31621376498"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4c16ddc0b3d746aed08fdf270f229c74b77f752e6da39117d401e24b8982ff8a"
    sha256 cellar: :any,                 arm64_sonoma:  "4c16ddc0b3d746aed08fdf270f229c74b77f752e6da39117d401e24b8982ff8a"
    sha256 cellar: :any,                 arm64_ventura: "4c16ddc0b3d746aed08fdf270f229c74b77f752e6da39117d401e24b8982ff8a"
    sha256 cellar: :any,                 sonoma:        "8c1509ae5417bc3f09ffdda2efcc1016a652ffbff482d5dff4bf7b99046cae0e"
    sha256 cellar: :any,                 ventura:       "8c1509ae5417bc3f09ffdda2efcc1016a652ffbff482d5dff4bf7b99046cae0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa647e385e9796029a1143c0094a93b1f55aa077fe0b30cc205f1fd63ad7e3e6"
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
