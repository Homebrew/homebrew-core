require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.60.0.tgz"
  sha256 "033376d305c55a5440e7dd1e1f636e2488e718bbd37d7911854c9cbd9fe21994"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b203012cad073814bd6abfc9bc45d467763f76cbe872a42df769638fa90f3867"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b203012cad073814bd6abfc9bc45d467763f76cbe872a42df769638fa90f3867"
    sha256 cellar: :any_skip_relocation, monterey:       "251f09a8e545c87107304e1b01dff2770aac74fa9a25eb26b583418d6ba2957f"
    sha256 cellar: :any_skip_relocation, big_sur:        "251f09a8e545c87107304e1b01dff2770aac74fa9a25eb26b583418d6ba2957f"
    sha256 cellar: :any_skip_relocation, catalina:       "251f09a8e545c87107304e1b01dff2770aac74fa9a25eb26b583418d6ba2957f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a227dfb6e4f03e8980ed3bee51da4a33a03f9d0233485b4d13d8e453a94bb11"
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
