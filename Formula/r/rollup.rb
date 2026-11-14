class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.68.3.tgz"
  sha256 "d60a21950213b4d483660d7d1f09e50ad677a0274d68e95a594e9fca5fd04c16"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "920ae86a3b6df45ce62c88e788ab0eb90368f18745dba008fd369386bdd186f8"
    sha256 cellar: :any,                 arm64_tahoe:       "920ae86a3b6df45ce62c88e788ab0eb90368f18745dba008fd369386bdd186f8"
    sha256 cellar: :any,                 arm64_sequoia:     "920ae86a3b6df45ce62c88e788ab0eb90368f18745dba008fd369386bdd186f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9c241f1bf3f7529ad72e19f1e96132cd3e5e7d206d7d891b726ea81b237f1a3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0ba610a15b2655683a04b97c9bfd303200bd91adf25c2e653c0e10ad30027883"
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
