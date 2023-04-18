require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.20.6.tgz"
  sha256 "4d1631120b94019228f931362e414ea4c5608a36252fe430c8f6b7b58fe05631"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c26db45ca4e7edcc908b76d0a678859c743a5724f1180a69a177a8c39e1c242c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c26db45ca4e7edcc908b76d0a678859c743a5724f1180a69a177a8c39e1c242c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c26db45ca4e7edcc908b76d0a678859c743a5724f1180a69a177a8c39e1c242c"
    sha256 cellar: :any_skip_relocation, ventura:        "e9ad50822ae8229a45373fbec61e3e2c1513ef3cb9bc30671a460ecf58564bd5"
    sha256 cellar: :any_skip_relocation, monterey:       "e9ad50822ae8229a45373fbec61e3e2c1513ef3cb9bc30671a460ecf58564bd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9ad50822ae8229a45373fbec61e3e2c1513ef3cb9bc30671a460ecf58564bd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be941ecae93440310c11d4723f11716c5928288fdc7de22a962b43183170d633"
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
