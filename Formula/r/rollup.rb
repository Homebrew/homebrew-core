class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.67.4.tgz"
  sha256 "5a83f6d2c389443153dd376b65fcff54d77f1391623b06f12bb2f51d3de44246"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "bb1816972660dd85ab61567c85201dc5e9eb036d602e549eb96bd0f7ab4b5db3"
    sha256 cellar: :any,                 arm64_tahoe:       "bb1816972660dd85ab61567c85201dc5e9eb036d602e549eb96bd0f7ab4b5db3"
    sha256 cellar: :any,                 arm64_sequoia:     "bb1816972660dd85ab61567c85201dc5e9eb036d602e549eb96bd0f7ab4b5db3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4ac799605c20e869cfa5a0f9480fd99672f6cb9df3e977551b36ed5c86b25b33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "92ee407c781bf13f0d9f1aadfbd37af592acfeee0575fa52cc10daf530cc4dc9"
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
