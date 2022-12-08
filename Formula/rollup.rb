require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.7.0.tgz"
  sha256 "ae1fa1d99612ddaf21c497398e67f1b1aa920987b6095fd364531862fd668f0f"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbed1277643655f50fc662f39b437a05b1567a51c36dc2c2acb40c9cd28488b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbed1277643655f50fc662f39b437a05b1567a51c36dc2c2acb40c9cd28488b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbed1277643655f50fc662f39b437a05b1567a51c36dc2c2acb40c9cd28488b7"
    sha256 cellar: :any_skip_relocation, ventura:        "04118ca0dd33636118311d4bdacd31d9458ba94341bd7930b6fdaa6a409cf689"
    sha256 cellar: :any_skip_relocation, monterey:       "04118ca0dd33636118311d4bdacd31d9458ba94341bd7930b6fdaa6a409cf689"
    sha256 cellar: :any_skip_relocation, big_sur:        "04118ca0dd33636118311d4bdacd31d9458ba94341bd7930b6fdaa6a409cf689"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08664bdf4362ad2316e2753ee661524176c3cfeac75984e9c5b8fedb93befdb7"
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
