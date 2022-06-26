require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.75.7.tgz"
  sha256 "781f47a18aa9b6262dcb3bdbd5cc7f142c37077bb5fd1d7b47ae13ca3c86b652"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d7aa4eba5e7f8c674f2101aa16355d2fb27ec4d58c0c83d9ea1ebb82a735d41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d7aa4eba5e7f8c674f2101aa16355d2fb27ec4d58c0c83d9ea1ebb82a735d41"
    sha256 cellar: :any_skip_relocation, monterey:       "3a2462d129f8118d41ea25454c664acbd1467f45ff0ef2d1b319f339c1f8070c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a2462d129f8118d41ea25454c664acbd1467f45ff0ef2d1b319f339c1f8070c"
    sha256 cellar: :any_skip_relocation, catalina:       "3a2462d129f8118d41ea25454c664acbd1467f45ff0ef2d1b319f339c1f8070c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d6eea42b809ecc32be21eb6fe16e8f687bd25a2f4ba23f204bb75a430f47cf6"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
