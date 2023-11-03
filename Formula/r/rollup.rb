require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.3.0.tgz"
  sha256 "7c3a8f1cb9b851c458c2e3f22aa23c3d68044fcc6f217cc6caddbacb723e0f90"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3863bc6c4abc097115bc98b1f790ef80c7e884c3aa98b46015533508c8849614"
    sha256 cellar: :any,                 arm64_ventura:  "3863bc6c4abc097115bc98b1f790ef80c7e884c3aa98b46015533508c8849614"
    sha256 cellar: :any,                 arm64_monterey: "3863bc6c4abc097115bc98b1f790ef80c7e884c3aa98b46015533508c8849614"
    sha256 cellar: :any,                 sonoma:         "8429d6b0ef91c7466c0320d634b5b846fe2d2851d7f2177c2cdf650d2ab652d4"
    sha256 cellar: :any,                 ventura:        "8429d6b0ef91c7466c0320d634b5b846fe2d2851d7f2177c2cdf650d2ab652d4"
    sha256 cellar: :any,                 monterey:       "8429d6b0ef91c7466c0320d634b5b846fe2d2851d7f2177c2cdf650d2ab652d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bc5ece994b9805d57e90b421b4b3a0c62a5b77a374851e6fca3d2bdd0d2796b"
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
