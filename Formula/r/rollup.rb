class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.68.4.tgz"
  sha256 "c17f68446f61cc7ab9aea654a2e3267a26ef32938767da796eadc272872b9121"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "79172f87e445a73e2fdfb3cdc1b5cf27f7ec3f4d8a45cd424117f66d967c9ab0"
    sha256 cellar: :any,                 arm64_tahoe:       "79172f87e445a73e2fdfb3cdc1b5cf27f7ec3f4d8a45cd424117f66d967c9ab0"
    sha256 cellar: :any,                 arm64_sequoia:     "79172f87e445a73e2fdfb3cdc1b5cf27f7ec3f4d8a45cd424117f66d967c9ab0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9396fdabd0a8c55b6937cd361195e7b36adbe2fb6ea59a56f2fd21339a9a7043"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "95799bafea528a55e7fc697d1f78e14a2da899f5a0ffc90b7c215a8365bbaadd"
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
