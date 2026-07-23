class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.62.2.tgz"
  sha256 "027a15633b3bb2daf879ad4002488050b636c2c56dc8a3a71348c87cfd363373"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "94876a9d5e67e0b1aad7e7579cbad8367302d5478394281194a807c4fd9e23ae"
    sha256 cellar: :any,                 arm64_sequoia: "855c6ce0763274cf0614b1189c936f782884917de86f9e4ae5d53330351bf78e"
    sha256 cellar: :any,                 arm64_sonoma:  "855c6ce0763274cf0614b1189c936f782884917de86f9e4ae5d53330351bf78e"
    sha256 cellar: :any,                 sonoma:        "9f7e56be5806fe982ede526ffa1d13e9b784100dcee99d6ab5f504a5f1b3b63a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f90f40b49f13da9ff0eee2d17e3cafc99312e974d79b5247b5b8b706859f942a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "397c8a56a15ec76c1ec1b2c6d03ce417b60eadbf6f8dc49f03c7e211d1d9758f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Replace universal binaries with their native slices
    node_modules = libexec/"lib/node_modules/rollup/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node"
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
