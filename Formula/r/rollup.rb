class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.68.0.tgz"
  sha256 "2cd00464fff4c8da3da7f1ba0321c0df64ba899b3afd5a3030e8be53687bbd88"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "c6a1e9dac1f6f041fbaa5e2c78edea16d7bb19ada8f8df50eddb1fa862cfca14"
    sha256 cellar: :any,                 arm64_tahoe:       "c6a1e9dac1f6f041fbaa5e2c78edea16d7bb19ada8f8df50eddb1fa862cfca14"
    sha256 cellar: :any,                 arm64_sequoia:     "c6a1e9dac1f6f041fbaa5e2c78edea16d7bb19ada8f8df50eddb1fa862cfca14"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "58eba1f646e1a90705737ff44e9fa19fdbe44241a2080a7acc7afef91d8a7f9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4ec18beeb8db2693b63007ef74b50ef6bf0699bebc7d8851bf2f81c8f9279872"
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
