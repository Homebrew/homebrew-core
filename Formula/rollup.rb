require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.14.0.tgz"
  sha256 "4dfe28e9b09390d073baee1aed3a9f69c02f04a81f80b3e984fbe0c69012a3e5"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ab347fd90bba1f31fe4c9ff6ec1bbe51941369d9939e4775c4b83e76c5f0831"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ab347fd90bba1f31fe4c9ff6ec1bbe51941369d9939e4775c4b83e76c5f0831"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ab347fd90bba1f31fe4c9ff6ec1bbe51941369d9939e4775c4b83e76c5f0831"
    sha256 cellar: :any_skip_relocation, ventura:        "388553d48e40e65cf3884aa4738a09c49a6ebce220c912474cdcb379405e9cd6"
    sha256 cellar: :any_skip_relocation, monterey:       "388553d48e40e65cf3884aa4738a09c49a6ebce220c912474cdcb379405e9cd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "388553d48e40e65cf3884aa4738a09c49a6ebce220c912474cdcb379405e9cd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85093dd07afb0a34a8d44dbf6f62323bd35c93f1609a7aa7ccd25839f67b900b"
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
