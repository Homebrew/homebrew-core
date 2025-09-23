class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.52.1.tgz"
  sha256 "73a15afdaa1755560ef578fbd89a8ef83729ff6ead27b9aa6062429be8d5b321"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6fc60c52cc4e5bca7de55741ceb802f27ebc162f4831c29d5873e3f603d8956e"
    sha256 cellar: :any,                 arm64_sequoia: "70dabaf46ced059ea989ca1346cd5d5972ae8dd06339f8713b752d220468b10b"
    sha256 cellar: :any,                 arm64_sonoma:  "70dabaf46ced059ea989ca1346cd5d5972ae8dd06339f8713b752d220468b10b"
    sha256 cellar: :any,                 sonoma:        "0694e5286a3918464b14ccba3a373b6efe8f2e3c2da6d18f1b60c424fddb1f1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbe92a0ea45669d55c125b01d3cf4294e206ad296a493c5d1cd70bdadac93969"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a6f71bb5c98a0c31e1fb36954b23d9e70bce562052dd2fb8459f97696d54efc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test/main.js").write <<~JS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    JS

    (testpath/"test/foo.js").write <<~JS
      export default 'hello world!';
    JS

    expected = <<~JS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    JS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end
