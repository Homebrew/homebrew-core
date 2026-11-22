class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.68.8.tgz"
  sha256 "fa470ad1b9676c850ea702465dbad4c9a796a64df6b79748dc3594431b2a2033"
  license all_of: ["ISC", "MIT"]

  bottle do
    manifest_sha256 "a7b0e4a96f0bc5411830667a75d324a2b9094a0f9935b9771299275af91b4e4e"
    sha256 cellar: :any,                 arm64_golden_gate: "da890ce7a118ae6cfb872ac38e34b2e2663e84f3b7ebc38bdc29ba2d94bc1286"
    sha256 cellar: :any,                 arm64_tahoe:       "da890ce7a118ae6cfb872ac38e34b2e2663e84f3b7ebc38bdc29ba2d94bc1286"
    sha256 cellar: :any,                 arm64_sequoia:     "da890ce7a118ae6cfb872ac38e34b2e2663e84f3b7ebc38bdc29ba2d94bc1286"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b5c784c41224e09e9f71b3213a836b2915f6c0d0d4cb4271b5458fe9ffdf186f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "93d0a8c2ca7b1f137d0e1de299051c02b95ff65cc25f3ab3ea821e1aa9f8b725"
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
