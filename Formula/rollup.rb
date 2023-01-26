require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.11.0.tgz"
  sha256 "3e727bde9f1fbf7409a04aa8a514f24cc509724e46d91e3896941da1193f5ba5"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8773a4620d6493585638b4a985bc4e163224391efc7db73d69912c6a9aee296"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8773a4620d6493585638b4a985bc4e163224391efc7db73d69912c6a9aee296"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8773a4620d6493585638b4a985bc4e163224391efc7db73d69912c6a9aee296"
    sha256 cellar: :any_skip_relocation, ventura:        "0d6931eee4b06e4a0abdee427a0a96f1f27c2782f3b38cb3ea9c50fc1b3736bd"
    sha256 cellar: :any_skip_relocation, monterey:       "0d6931eee4b06e4a0abdee427a0a96f1f27c2782f3b38cb3ea9c50fc1b3736bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d6931eee4b06e4a0abdee427a0a96f1f27c2782f3b38cb3ea9c50fc1b3736bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1fda0073b5569e4fc2e46aaae2dc1047443dd3271ac274247af9fbd5dbfdd55"
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
