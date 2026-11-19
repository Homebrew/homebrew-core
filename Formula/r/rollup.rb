class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.68.6.tgz"
  sha256 "87abe65d0ae937b9d984554af3c42e0d8932c134ca2490390df9a0c9049c5f3e"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "649af1471d70947c2f0884751c42c529cf4f033ff82af082a89e2df44fd906ee"
    sha256 cellar: :any,                 arm64_tahoe:       "649af1471d70947c2f0884751c42c529cf4f033ff82af082a89e2df44fd906ee"
    sha256 cellar: :any,                 arm64_sequoia:     "649af1471d70947c2f0884751c42c529cf4f033ff82af082a89e2df44fd906ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "040ce6f80c99be6ca45eb84903af298b1523448398d05ae5e9ed57653e03ddd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6884a310fa174976fef71e39a171ba3cc6e76d32854093a586a4b5646fb0d383"
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
