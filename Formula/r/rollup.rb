class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.59.0.tgz"
  sha256 "219f4b5e57aa37029a6070c3f07746fb6feeb3459ba6ddc95e59248e79d94d56"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cfe9060e90ecaf4365e5a8e6637db99a14655f86279f89d0fe953f1ea240c4ca"
    sha256 cellar: :any,                 arm64_sequoia: "397416d17c4fc6c096eb3f5e6579ad4aa39b1134c497b7d0ce56c0bb07002cc4"
    sha256 cellar: :any,                 arm64_sonoma:  "397416d17c4fc6c096eb3f5e6579ad4aa39b1134c497b7d0ce56c0bb07002cc4"
    sha256 cellar: :any,                 sonoma:        "5584f8ef5e130abe0499708855ee01292345fe87cd35ff3d65770d315d929c10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fc755b1252565809b34995a1e78e64003372ce3a175d94703b4682ba2a63098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53573f45b191a5266e1ac61cec54b4389566754b29200e65e2523eecda3d5959"
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
