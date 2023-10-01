require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.29.3.tgz"
  sha256 "1cba605badafa15c9f855fa606a60578579b4389bf6397f809b21d7d00748606"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f02b33d5b1922e9b9d503a24d82f0b9258afcd5068ad047e75a0da57380fe40f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f02b33d5b1922e9b9d503a24d82f0b9258afcd5068ad047e75a0da57380fe40f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f02b33d5b1922e9b9d503a24d82f0b9258afcd5068ad047e75a0da57380fe40f"
    sha256 cellar: :any_skip_relocation, ventura:        "59470cd7cc9372a1d2d75081df33b6c8fe872c5061a5b060d6d2453d5e677e4d"
    sha256 cellar: :any_skip_relocation, monterey:       "59470cd7cc9372a1d2d75081df33b6c8fe872c5061a5b060d6d2453d5e677e4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "59470cd7cc9372a1d2d75081df33b6c8fe872c5061a5b060d6d2453d5e677e4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0a4dc527ecf5fdeedc88cc9edfd86342a6ddc7a425e59cad4a046474c6332d7"
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
