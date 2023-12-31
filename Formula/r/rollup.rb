require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.9.2.tgz"
  sha256 "d650e76dae977414c1971c943ce007898686248661de1e04e0e054b23b34cfed"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8242eaac4c6887bd338b30eec14ce379574bab1d534279bf6c4569e61ba57d6a"
    sha256 cellar: :any,                 arm64_ventura:  "8242eaac4c6887bd338b30eec14ce379574bab1d534279bf6c4569e61ba57d6a"
    sha256 cellar: :any,                 arm64_monterey: "8242eaac4c6887bd338b30eec14ce379574bab1d534279bf6c4569e61ba57d6a"
    sha256 cellar: :any,                 sonoma:         "36046f6c5c17e793eb70716757d02170a5ba42609539923fb1c819836cdbc318"
    sha256 cellar: :any,                 ventura:        "36046f6c5c17e793eb70716757d02170a5ba42609539923fb1c819836cdbc318"
    sha256 cellar: :any,                 monterey:       "36046f6c5c17e793eb70716757d02170a5ba42609539923fb1c819836cdbc318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73c48b3e27dc23d9846749c0ef88f4dd24c228054d11cc6669c6111b4a855394"
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
