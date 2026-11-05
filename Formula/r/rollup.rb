class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.67.5.tgz"
  sha256 "c0af59e02f577c16227a06af8ae968f98b5a994105ca6b67fffd42bd6c6a5e34"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "67b59712faf0e4d63cd94a3eeec4f48032b2113d94c551b20a55d60baadddbc8"
    sha256 cellar: :any,                 arm64_tahoe:       "67b59712faf0e4d63cd94a3eeec4f48032b2113d94c551b20a55d60baadddbc8"
    sha256 cellar: :any,                 arm64_sequoia:     "67b59712faf0e4d63cd94a3eeec4f48032b2113d94c551b20a55d60baadddbc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e7d182021c91e125bc3982ff9720c73a2f6c532483d8ecbeaeef7f20de866347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "120cb348d409dc8409e42b1c1fafccf3de20515ebcda4859051c272ad5c50667"
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
