require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.1.4.tgz"
  sha256 "bf6e4cae9743b8638b3305f42870cb9107f13c4416f1d160e13078183e39a120"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bac9c02707d380edf5741e847e49619f870082009db85227153d1d79b12ade37"
    sha256 cellar: :any,                 arm64_ventura:  "bac9c02707d380edf5741e847e49619f870082009db85227153d1d79b12ade37"
    sha256 cellar: :any,                 arm64_monterey: "bac9c02707d380edf5741e847e49619f870082009db85227153d1d79b12ade37"
    sha256 cellar: :any,                 sonoma:         "425a09da159ef51dc447cb552055373a82b1fe76ff164d4179cd5d500cdeb57a"
    sha256 cellar: :any,                 ventura:        "425a09da159ef51dc447cb552055373a82b1fe76ff164d4179cd5d500cdeb57a"
    sha256 cellar: :any,                 monterey:       "425a09da159ef51dc447cb552055373a82b1fe76ff164d4179cd5d500cdeb57a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1ea8c52e663686633cb0e2d76a221a15cf6d48ebcb0928f5bc808fcd58a6cde"
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
