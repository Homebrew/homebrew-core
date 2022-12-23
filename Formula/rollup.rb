require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.8.1.tgz"
  sha256 "4b6c5cd740b68fd33649a686c6a2e2dec7a6d8235023d89880936b7a538bff32"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37e052128df27377b400074c2b1c9b599a243d58d96a0ba41ccb7d05dceaf5a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37e052128df27377b400074c2b1c9b599a243d58d96a0ba41ccb7d05dceaf5a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37e052128df27377b400074c2b1c9b599a243d58d96a0ba41ccb7d05dceaf5a7"
    sha256 cellar: :any_skip_relocation, ventura:        "fb2b13fb0bfc22ea4582db008eb0855b91899265d2fad476cc7e556442067cd7"
    sha256 cellar: :any_skip_relocation, monterey:       "fb2b13fb0bfc22ea4582db008eb0855b91899265d2fad476cc7e556442067cd7"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb2b13fb0bfc22ea4582db008eb0855b91899265d2fad476cc7e556442067cd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54bc0d4053f18bf3a4554310ea3d57f21787ed2b616780d7018fc8763571eee9"
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
