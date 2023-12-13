require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.9.0.tgz"
  sha256 "ddf1e8fec41abdba5dbfdac02157c991b4cd88f150dcad4f2d369735ee31e833"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "77e72ffb9d60b687f11eebfc765228cfca15b3090aa2f1981825e15e0d6e649c"
    sha256 cellar: :any,                 arm64_ventura:  "77e72ffb9d60b687f11eebfc765228cfca15b3090aa2f1981825e15e0d6e649c"
    sha256 cellar: :any,                 arm64_monterey: "77e72ffb9d60b687f11eebfc765228cfca15b3090aa2f1981825e15e0d6e649c"
    sha256 cellar: :any,                 sonoma:         "ee4abe289e162bb92150a5053d51498e6371b2600395655329b788405ec4f3db"
    sha256 cellar: :any,                 ventura:        "ee4abe289e162bb92150a5053d51498e6371b2600395655329b788405ec4f3db"
    sha256 cellar: :any,                 monterey:       "ee4abe289e162bb92150a5053d51498e6371b2600395655329b788405ec4f3db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f2986482b14a0642a1ad1c1e8d142b8db1ad79369be1afed901fefbc60879a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/rollup/node_modules"
    (node_modules/"@rollup/rollup-linux-x64-musl/rollup.linux-x64-musl.node").unlink if OS.linux?

    deuniversalize_machos
  end

  test do
    (testpath/"test/main.js").write <<~EOS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    EOS

    (testpath/"test/foo.js").write <<~EOS
      export default 'hello world!';
    EOS

    expected = <<~EOS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    EOS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end
