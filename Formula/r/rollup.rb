class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.68.1.tgz"
  sha256 "b12cbc3c11f0c49401d4d2a74a21cfbbbbfd158189a11987c54539e748d004c0"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "90fcfe30013f0ad26e55f400f735733b5086db09e332e7293430cb608189ed4c"
    sha256 cellar: :any,                 arm64_tahoe:       "90fcfe30013f0ad26e55f400f735733b5086db09e332e7293430cb608189ed4c"
    sha256 cellar: :any,                 arm64_sequoia:     "90fcfe30013f0ad26e55f400f735733b5086db09e332e7293430cb608189ed4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "82e205237e3e84bc174c1e4b2a43089f2f9a1bb0c967d034dc62796d03b036d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "62d4d93e9588577107f75a3bf056e2b6c036ac82300797b8d18cb37d35112bcf"
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
