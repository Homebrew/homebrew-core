require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.65.0.tgz"
  sha256 "06f5b6e171f02792afc75955dd2191c07f70a6e7d5a9c6c800f3ed903fb9e9ca"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24179718d7c6ac00b5c464007bc9e7d410a54c2979c2a2d45f8f39ae2a7a3cee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24179718d7c6ac00b5c464007bc9e7d410a54c2979c2a2d45f8f39ae2a7a3cee"
    sha256 cellar: :any_skip_relocation, monterey:       "385a104555452967159ac81ca8ad3ff5e811d2c1f86abe22e5ce5d735fea9b48"
    sha256 cellar: :any_skip_relocation, big_sur:        "385a104555452967159ac81ca8ad3ff5e811d2c1f86abe22e5ce5d735fea9b48"
    sha256 cellar: :any_skip_relocation, catalina:       "385a104555452967159ac81ca8ad3ff5e811d2c1f86abe22e5ce5d735fea9b48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f5d971def08c5bff49372356978e6e992d2f2ed4f4a5577492cc714733c1625"
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
