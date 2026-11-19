class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.68.7.tgz"
  sha256 "05b01ada4d2c374026403df09bae4a715b716ffc7aa975c468be3eb5c7042b62"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "a4b0a021923059a69cdb49d4ab233f83610869a3996f7fb932a78bac9f1b5b31"
    sha256 cellar: :any,                 arm64_tahoe:       "a4b0a021923059a69cdb49d4ab233f83610869a3996f7fb932a78bac9f1b5b31"
    sha256 cellar: :any,                 arm64_sequoia:     "a4b0a021923059a69cdb49d4ab233f83610869a3996f7fb932a78bac9f1b5b31"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c8b465b2ddb14988f889447024ea74c1921a8ed779591d8b64abd0a03fe2e7aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ec71d58e4addfe4e060e989a154d0791578bdf4a07150706b60a10040cd39047"
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
