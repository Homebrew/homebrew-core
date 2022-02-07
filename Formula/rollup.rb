require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.67.1.tgz"
  sha256 "921e0d8b720cacbf84870975efd624ca30a2fc58a94453bb231519d65d4cd307"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "246239271d85422d44ddde297a29812bc3b0d3b2d2c177a4e801529b353b57fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "246239271d85422d44ddde297a29812bc3b0d3b2d2c177a4e801529b353b57fa"
    sha256 cellar: :any_skip_relocation, monterey:       "7bb3bdd52020a8d9a2091e64878240698f29d3cb333a930c8d1b3f36af4e8a6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bb3bdd52020a8d9a2091e64878240698f29d3cb333a930c8d1b3f36af4e8a6b"
    sha256 cellar: :any_skip_relocation, catalina:       "7bb3bdd52020a8d9a2091e64878240698f29d3cb333a930c8d1b3f36af4e8a6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33b0d706a299ea31bbaf615cb53d49784f0c3a1366007bb14a1b45547ab37714"
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
