require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.12.0.tgz"
  sha256 "28434c5d0cdb42e672f3cfebb7c13764e6e92bfa15f69e5fb0b3c3989ccbefd2"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6721f4be8c1a86421c548ebea53b8aba9c9cf6add11fe8f2827c39b1dd6bfdb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6721f4be8c1a86421c548ebea53b8aba9c9cf6add11fe8f2827c39b1dd6bfdb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6721f4be8c1a86421c548ebea53b8aba9c9cf6add11fe8f2827c39b1dd6bfdb7"
    sha256 cellar: :any_skip_relocation, ventura:        "360ad8857ded6d450292b9c72c1f615a26e65972d589c008996e3b080be36de6"
    sha256 cellar: :any_skip_relocation, monterey:       "360ad8857ded6d450292b9c72c1f615a26e65972d589c008996e3b080be36de6"
    sha256 cellar: :any_skip_relocation, big_sur:        "360ad8857ded6d450292b9c72c1f615a26e65972d589c008996e3b080be36de6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be344f1aa7c894d555ce8767418720faed2cf60a904911e383120651c97ee87f"
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
