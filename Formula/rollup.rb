require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.77.3.tgz"
  sha256 "384d550745ee5b9a1a9953f754570c4864c2a691c4d265bf5747e9168b33d7f2"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "726c8f78a6c0e0119e9a9656741d6d6dad3b15b35f70ce45c1a9d06fbceea492"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "726c8f78a6c0e0119e9a9656741d6d6dad3b15b35f70ce45c1a9d06fbceea492"
    sha256 cellar: :any_skip_relocation, monterey:       "f9eedf52c64b2234500f0135d4db517b48ed6ce37e69c9c3b3473f33e4782a81"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9eedf52c64b2234500f0135d4db517b48ed6ce37e69c9c3b3473f33e4782a81"
    sha256 cellar: :any_skip_relocation, catalina:       "f9eedf52c64b2234500f0135d4db517b48ed6ce37e69c9c3b3473f33e4782a81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9091e323c653cef2b368d5facbba3477e40c5ab04d7d24ecec63c6f8755e4feb"
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
