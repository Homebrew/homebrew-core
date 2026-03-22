class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.59.1.tgz"
  sha256 "81543a54adb318c576efdf502bb061db868ebb1847f0bf26d38e261b26a16dff"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "afc8742af38cb14defb6eff719a9c9ce49751404497e5dbab89a643e299ad2f6"
    sha256 cellar: :any,                 arm64_sequoia: "4c9964fa276fa8770dc1e952e10646a05eba8eb8b420c99ff7d19bb7c6554bbf"
    sha256 cellar: :any,                 arm64_sonoma:  "4c9964fa276fa8770dc1e952e10646a05eba8eb8b420c99ff7d19bb7c6554bbf"
    sha256 cellar: :any,                 sonoma:        "79b705fde153983de94481ed47028b63303c93c711eb7cd50dba37c81bce01ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b451d5fb6adbd3329943cd5e39383991dfd2afc9bd919eba49e9d3f621ed4bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d484b2eefd110e9e9001f2c78f762fc5c1abbf518bc8ebcbd613fea0fcf81b33"
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
