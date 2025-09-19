class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.51.0.tgz"
  sha256 "c5d295d4ab6180cd0bb2c8b677a80bde4d5a7a9af3a85de99351d5d18f09fe14"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2cd2ce162912084392d2c531e59d9c89a92bf9d4bde914742ec72f6ca66a6cde"
    sha256 cellar: :any,                 arm64_sequoia: "c5458d0a9afe7d456a039c2a389cbebf47cca3f18043353d712f1643a5835f17"
    sha256 cellar: :any,                 arm64_sonoma:  "c5458d0a9afe7d456a039c2a389cbebf47cca3f18043353d712f1643a5835f17"
    sha256 cellar: :any,                 sonoma:        "50c17d2051d8998b646d14255a9f3337472bf7d28f2eb28970abe5e8c864a915"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95fe392fd813caadf1e55e473667a7a4cf90bc6362e8d9259e5becc7d46d1878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58dfe929cd536ac53bf2f7b07ec6bb08c140ec8191597d9f73fa2ab3784a52bf"
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
