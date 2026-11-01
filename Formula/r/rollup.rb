class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.67.3.tgz"
  sha256 "a7f55159ec42cd62fe0b58a7075f32555bd1be2989b9cf3a3f37ef0c270d730a"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "b105165c8e871bade3319e3b93cd095b8e2aec0f183f4c233abf3e622eb943bd"
    sha256 cellar: :any,                 arm64_tahoe:       "b105165c8e871bade3319e3b93cd095b8e2aec0f183f4c233abf3e622eb943bd"
    sha256 cellar: :any,                 arm64_sequoia:     "b105165c8e871bade3319e3b93cd095b8e2aec0f183f4c233abf3e622eb943bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e8f9f19a0575470a96a321b465849a1ad89a177930748a74d2e86627866d5af3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "09c075563475f98275e8804d63d02026a1bc2ed556469739e50b10e5e742196d"
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
