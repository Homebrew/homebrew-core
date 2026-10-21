class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.64.10.tgz"
  sha256 "ff2cfd016753bd2e4c7532cee65b225ee9ebe4d75249dac1f8b0389cb6ec6df5"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "29b8693535cb14d9bbe5a38b682e4872c642d8d770d5e0e994979cc67163907e"
    sha256 cellar: :any,                 arm64_tahoe:       "29b8693535cb14d9bbe5a38b682e4872c642d8d770d5e0e994979cc67163907e"
    sha256 cellar: :any,                 arm64_sequoia:     "29b8693535cb14d9bbe5a38b682e4872c642d8d770d5e0e994979cc67163907e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0b65531a8279f34475090c331f5117b9e4b085c21f41944a67a5410c4726668f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d2e8693f72a51db11321703cbf78827c87f66da506c42c98e5f734ddd68f1600"
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
