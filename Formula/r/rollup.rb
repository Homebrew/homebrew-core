class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.55.3.tgz"
  sha256 "5a9f64b11dcad057744df75329fb9c0fdbf545f1923000835e3869d6b27d3145"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "84249159827797c24eaaaddf5128f6b4d405bcfad2820db9d4ce739b631f84af"
    sha256 cellar: :any,                 arm64_sequoia: "a150f7a36a48de69a363869e98a447faa285eb3d7ef3061231fb7496ea97e5bf"
    sha256 cellar: :any,                 arm64_sonoma:  "a150f7a36a48de69a363869e98a447faa285eb3d7ef3061231fb7496ea97e5bf"
    sha256 cellar: :any,                 sonoma:        "c71a0122a1e580f6a9dbaf1d6a05e6ec2d59c6eb52851f3e1b0908f813a60838"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "276e10a319bd87e7c3e8d416bf23aa92ce98cf5c2a0f72756437881b5a89adbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fefa31a5603d5059d6cc200c8656e690035857082d6d154c3f9e287442e2812"
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
