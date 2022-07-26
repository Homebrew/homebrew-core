require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.77.1.tgz"
  sha256 "137ff753b2a5ebb453c912783cd58ec13e247aa7f591bd3dded5f579615557a6"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b3fc63014cd299aa7cabdc37803559988fa14b01b492ad0aec3e72b34c99262"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b3fc63014cd299aa7cabdc37803559988fa14b01b492ad0aec3e72b34c99262"
    sha256 cellar: :any_skip_relocation, monterey:       "d02c555df01dcc1b7a901c509198929a37e95f053c25f9fc922a7b8534d366ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "d02c555df01dcc1b7a901c509198929a37e95f053c25f9fc922a7b8534d366ab"
    sha256 cellar: :any_skip_relocation, catalina:       "d02c555df01dcc1b7a901c509198929a37e95f053c25f9fc922a7b8534d366ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc90b7f66826a425e5cbfcaad1ecedd078acc61762311d48d595e9682affd6a9"
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
