require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.18.0.tgz"
  sha256 "f370190d3ce6ee3d8c8899330bdfedb7d3ec2a3158f71998c5e4e5fcdeed0624"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a02fce61d39e610ad401dd47d5aad46d7b75f4597bf80a2fee9d41444d652be3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a02fce61d39e610ad401dd47d5aad46d7b75f4597bf80a2fee9d41444d652be3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a02fce61d39e610ad401dd47d5aad46d7b75f4597bf80a2fee9d41444d652be3"
    sha256 cellar: :any_skip_relocation, ventura:        "e9e159027c24b73c70cd99ac0b8a07ad65e817a4f709df22f7816f2e4b25260b"
    sha256 cellar: :any_skip_relocation, monterey:       "e9e159027c24b73c70cd99ac0b8a07ad65e817a4f709df22f7816f2e4b25260b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9e159027c24b73c70cd99ac0b8a07ad65e817a4f709df22f7816f2e4b25260b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0087c9087d0de8f29be56dbf360b565c64511e8aff940d3d0f14d53ea78c608"
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
