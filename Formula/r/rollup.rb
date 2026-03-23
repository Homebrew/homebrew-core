class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.60.0.tgz"
  sha256 "6a0e6e04a0767d3bec57121dd1dcad71ab30caa0704e69a8efd52fb15237e294"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d6eadabade69a5e35e17b6918f492fa4601eb91a79b368c92debe1b8fd8c17b8"
    sha256 cellar: :any,                 arm64_sequoia: "aee6e4c00c80b2c0e301fb62eb5ca8aff65c003af406fa52a9652ebb382869b6"
    sha256 cellar: :any,                 arm64_sonoma:  "aee6e4c00c80b2c0e301fb62eb5ca8aff65c003af406fa52a9652ebb382869b6"
    sha256 cellar: :any,                 sonoma:        "df9a807310cf52ced65a8381c224345e23c2d7bbbcbab0922715bd201846c297"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ca611a4e85411cd1b1d240b9fbc0f6cc5945a873872d1832123316c85d16dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "788d5df9106323bccc5ab35b19b0b2f8fa00e2d42ffb9b967384189901d3598d"
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
