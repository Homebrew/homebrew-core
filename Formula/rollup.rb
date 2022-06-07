require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.75.6.tgz"
  sha256 "69a1670e2702f72781aceec1924d4f3d3eee2610de01a6376f17c93b7ad24bae"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb50424c583ab55e4c984ddb76c0b06531c8136a42eb3f9842b422fd8eb57689"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb50424c583ab55e4c984ddb76c0b06531c8136a42eb3f9842b422fd8eb57689"
    sha256 cellar: :any_skip_relocation, monterey:       "c0a483b3ded85725bc85d5090b5fb91652a20aa79afcfe8c19614d3401599f95"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0a483b3ded85725bc85d5090b5fb91652a20aa79afcfe8c19614d3401599f95"
    sha256 cellar: :any_skip_relocation, catalina:       "c0a483b3ded85725bc85d5090b5fb91652a20aa79afcfe8c19614d3401599f95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb345468ae46e795091a8200e7a9ff6cde5da54142a41ae26a82043fc68022a8"
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
