class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.34.4.tgz"
  sha256 "a9b98d5de18a43a74a4c9805ee7a03f3de84fada15f1b20cdbebbdbbc20ffdee"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4601f9823b4a373ee04c968c9746633dce5cdda74f25013e5b2ce4368673a9dd"
    sha256 cellar: :any,                 arm64_sonoma:  "4601f9823b4a373ee04c968c9746633dce5cdda74f25013e5b2ce4368673a9dd"
    sha256 cellar: :any,                 arm64_ventura: "4601f9823b4a373ee04c968c9746633dce5cdda74f25013e5b2ce4368673a9dd"
    sha256 cellar: :any,                 sonoma:        "a65ed1db699e81e84040e742b7c803c1d699e88c7ef6c8b92e7a51ff74ea607f"
    sha256 cellar: :any,                 ventura:       "a65ed1db699e81e84040e742b7c803c1d699e88c7ef6c8b92e7a51ff74ea607f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a4cc582d9fedc5ccab42db0d5b096150e3168e4207c43d10df4df3c3009c1c8"
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
