class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.60.3.tgz"
  sha256 "9c1bb486f0b1d4bf26fbf2db39a4e8b5045b6942a72ec12a52e8783f3a96cd29"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "465ebc8a46fc80a01ff968c094e916f92ae2fca9d2291a4c25bce2231083974a"
    sha256 cellar: :any,                 arm64_sequoia: "b21f7d8f451bb38f60adbb5410610e440c4af4d70e930a044308db7d737eb825"
    sha256 cellar: :any,                 arm64_sonoma:  "b21f7d8f451bb38f60adbb5410610e440c4af4d70e930a044308db7d737eb825"
    sha256 cellar: :any,                 sonoma:        "c4df56ab0e2304a6c3e13774323cb6ffa805490919710075ecc0b278b9c40c90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4323f1af7c1565c2ed38035f912d68d06d624ce9a57e53dfe06804f7c698a961"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a3f65faeaf3e25a0dff0af9d531c1648e5c21cd71fac0b6fb2a72854610cb34"
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
