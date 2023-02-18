require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.17.1.tgz"
  sha256 "1ed5781b2355d22fbf81c8aa2331ecf892a44e3adb53eadd90603277718fe7c5"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73de7f0b3d9e073c60d19ba04dcf19f31440da6a8e6b7bed21d18c9ba920301a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73de7f0b3d9e073c60d19ba04dcf19f31440da6a8e6b7bed21d18c9ba920301a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73de7f0b3d9e073c60d19ba04dcf19f31440da6a8e6b7bed21d18c9ba920301a"
    sha256 cellar: :any_skip_relocation, ventura:        "44e7a2192aaf0254b164bf840f4e2c97eaa2472cf27f1c36e19b96b64dd86e37"
    sha256 cellar: :any_skip_relocation, monterey:       "44e7a2192aaf0254b164bf840f4e2c97eaa2472cf27f1c36e19b96b64dd86e37"
    sha256 cellar: :any_skip_relocation, big_sur:        "44e7a2192aaf0254b164bf840f4e2c97eaa2472cf27f1c36e19b96b64dd86e37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb17f31953fb81981f0646bed328a286ebe298a0c4daf42b8fafb9c4f052e9ae"
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
