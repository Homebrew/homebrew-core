require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.74.1.tgz"
  sha256 "5b7e51a6705f541e96d17ee310ab59aa338796588086db49156fe53a7988f2f6"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18390b33430580ec17fb9f5e25054ed203257b59866b96ee43c1cf6cfa9af390"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18390b33430580ec17fb9f5e25054ed203257b59866b96ee43c1cf6cfa9af390"
    sha256 cellar: :any_skip_relocation, monterey:       "1c501f37c9a9edf92498edf1337c260690ab2f197b6d84550f3aec41aa2cd5c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c501f37c9a9edf92498edf1337c260690ab2f197b6d84550f3aec41aa2cd5c2"
    sha256 cellar: :any_skip_relocation, catalina:       "1c501f37c9a9edf92498edf1337c260690ab2f197b6d84550f3aec41aa2cd5c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fcead3a6c1aa006d2d969d5739aa8710cc6c1bdcad1b717246f7aeab340e015"
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
