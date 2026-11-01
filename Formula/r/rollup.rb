class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.67.3.tgz"
  sha256 "a7f55159ec42cd62fe0b58a7075f32555bd1be2989b9cf3a3f37ef0c270d730a"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "fe5114691405173a29adb6af7a85bddc5661eee497054649d4e3fe2ff2d2a4ee"
    sha256 cellar: :any,                 arm64_tahoe:       "fe5114691405173a29adb6af7a85bddc5661eee497054649d4e3fe2ff2d2a4ee"
    sha256 cellar: :any,                 arm64_sequoia:     "fe5114691405173a29adb6af7a85bddc5661eee497054649d4e3fe2ff2d2a4ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "475dee157877632339b3665fe2549d8f99944423125cc3e7b452a1159168d4fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a97a9904f37c6ebf64dd02ba4d984d42222330196cd63731f83b957f9562f2d5"
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
