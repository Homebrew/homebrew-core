class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.57.1.tgz"
  sha256 "71869d003aa83239fc10b613e8a0592cae5cd37c00651e94032d44d8ca7662f2"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0ce96c3778d15b1ee045ab752851a7b930b1a2ef5b22186e97222c6901d8dbb7"
    sha256 cellar: :any,                 arm64_sequoia: "0ca11b5c3987d4f760edc0ae72c5147c932ab061335a35422e23f40f6b85d34d"
    sha256 cellar: :any,                 arm64_sonoma:  "0ca11b5c3987d4f760edc0ae72c5147c932ab061335a35422e23f40f6b85d34d"
    sha256 cellar: :any,                 sonoma:        "5f8ea53b9bb31e7ebc31978489d01f5d75c90b6332ddc6c8e80befefe74ad176"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a456785a2fb80dfd4b039e9fc4199c3dc5fabf31d30e9f9dbe35249ebf59f7e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6d74759b224d0f6587e2577b4f46e353efe3e3d41b6c638b08cd67cb963d6aa"
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
