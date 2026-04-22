class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.60.2.tgz"
  sha256 "aaaf63ed4fd12d68457c85654144e750da49e4936f94267e747845cd5ac991c8"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1854d0fa9b3e8266c1627bd4466416b08135beee40bddf5b22af4c85ac5b477e"
    sha256 cellar: :any,                 arm64_sequoia: "7267f03e9d4b306284bfdce1b949f47cfd98052313a748a3e88f2babf896b2a6"
    sha256 cellar: :any,                 arm64_sonoma:  "7267f03e9d4b306284bfdce1b949f47cfd98052313a748a3e88f2babf896b2a6"
    sha256 cellar: :any,                 sonoma:        "e8a8d5324f9910490716ba4b0fe291e23788200921d86b56c3532a1aca14858d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd4c8b2436258cf94d5fd3601756cf1ab40ae4f4b0d3063e98f6f92c06c7d739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f0948da96ad047f254c9b5a7f1ecef83610963c32f1cec40fcd68bfa32098ac"
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
