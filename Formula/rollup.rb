require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.2.5.tgz"
  sha256 "1d1e479e9f58696aa131bde2df985b08660e5f25b3fb80d54f95f35bd33f1526"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0b22cdb2f89d53493cbc55665a2393543958819d98989fa80cbb124e39f590b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0b22cdb2f89d53493cbc55665a2393543958819d98989fa80cbb124e39f590b"
    sha256 cellar: :any_skip_relocation, monterey:       "4d5ec11b61026717f5e60f28592c92db88e8f5d5cdb433fc0e2cd8bf474886e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d5ec11b61026717f5e60f28592c92db88e8f5d5cdb433fc0e2cd8bf474886e6"
    sha256 cellar: :any_skip_relocation, catalina:       "4d5ec11b61026717f5e60f28592c92db88e8f5d5cdb433fc0e2cd8bf474886e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fab41c9a796b4d3adf7d7aceb244bf37fc596f9b9224a510d7c1ba6e85546515"
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
