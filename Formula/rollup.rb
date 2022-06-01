require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.75.5.tgz"
  sha256 "807d211af2bc02d10f0814bc186d1927beac5feab0afdcaeb6f5871484c7cbd3"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82a97e2ee37a71d76b24aa35d37db81799cb958e79bef51a88456badf8b83900"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82a97e2ee37a71d76b24aa35d37db81799cb958e79bef51a88456badf8b83900"
    sha256 cellar: :any_skip_relocation, monterey:       "b73d51911ccb66d573e9dbdd145a6979924cc368aa224aca87f7965e165cf739"
    sha256 cellar: :any_skip_relocation, big_sur:        "b73d51911ccb66d573e9dbdd145a6979924cc368aa224aca87f7965e165cf739"
    sha256 cellar: :any_skip_relocation, catalina:       "b73d51911ccb66d573e9dbdd145a6979924cc368aa224aca87f7965e165cf739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5c8dbff9dcdfd3de8877a1211a9b82b42941acb39a74e19f438904f98864b08"
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
