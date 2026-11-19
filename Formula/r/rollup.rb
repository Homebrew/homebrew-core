class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.68.6.tgz"
  sha256 "87abe65d0ae937b9d984554af3c42e0d8932c134ca2490390df9a0c9049c5f3e"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "00a33437af7359fbfbef0432c397e2e2e04ae20ba123d78915e7bd29f024f0b3"
    sha256 cellar: :any,                 arm64_tahoe:       "00a33437af7359fbfbef0432c397e2e2e04ae20ba123d78915e7bd29f024f0b3"
    sha256 cellar: :any,                 arm64_sequoia:     "00a33437af7359fbfbef0432c397e2e2e04ae20ba123d78915e7bd29f024f0b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6a78483da46bbc4447156bfb3fd517473bad558f4c51aacab217d1462eb30dac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e881f43ee15444dc41b3a974c1e1b592bec21fc70d0e6bd4067308857edbe95e"
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
